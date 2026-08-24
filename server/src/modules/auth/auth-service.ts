import { createHash, randomBytes } from 'node:crypto';

import type { FastifyInstance } from 'fastify';

import type { AppConfig } from '../../config.js';
import { ApiError } from '../../core/api-error.js';
import type { DatabaseClient } from '../../db/client.js';

type UserRow = {
  id: string;
  phone_e164: string;
  display_name: string | null;
};

type MembershipRow = {
  id: string;
  name: string;
  base_currency_code: string;
  role: 'owner' | 'manager' | 'cashier' | 'accountant' | 'viewer';
};

type AuthSession = {
  accessToken: string;
  refreshToken: string;
  accessTokenExpiresAt: string;
  user: {
    id: string;
    phone: string;
    displayName: string | null;
  };
  organizations: Array<{
    id: string;
    name: string;
    baseCurrencyCode: string;
    role: MembershipRow['role'];
  }>;
};

export class AuthService {
  constructor(
    private readonly database: DatabaseClient,
    private readonly app: FastifyInstance,
    private readonly config: AppConfig,
  ) {}

  async requestOtp(phone: string): Promise<{ accepted: true; expiresInSeconds: number }> {
    const [recent] = await this.database<{ count: string }[]>`
      SELECT count(*)::text AS count
      FROM otp_challenges
      WHERE phone_e164 = ${phone}
        AND created_at > now() - interval '15 minutes'
    `;

    if (Number(recent?.count ?? '0') >= 5) {
      throw new ApiError(429, 'OTP_RATE_LIMITED', 'تم تجاوز حد طلب الرموز. حاول لاحقاً.');
    }

    if (this.config.OTP_PROVIDER !== 'development') {
      throw new ApiError(503, 'OTP_PROVIDER_UNAVAILABLE', 'مزود التحقق غير متاح حالياً.');
    }

    const code = this.config.OTP_DEVELOPMENT_CODE;
    if (!code) {
      throw new ApiError(500, 'OTP_CONFIGURATION_ERROR', 'إعداد التحقق غير مكتمل.');
    }

    await this.database`
      INSERT INTO otp_challenges (phone_e164, code_hash, expires_at)
      VALUES (${phone}, ${this.hashOtp(phone, code)}, now() + interval '10 minutes')
    `;

    return { accepted: true, expiresInSeconds: 600 };
  }

  async verifyOtp(phone: string, code: string, deviceId: string): Promise<AuthSession> {
    const user = await this.database.begin(async (transaction) => {
      const [challenge] = await transaction<{
        id: string;
        code_hash: string;
        attempt_count: number;
      }[]>`
        SELECT id, code_hash, attempt_count
        FROM otp_challenges
        WHERE phone_e164 = ${phone}
          AND verified_at IS NULL
          AND expires_at > now()
        ORDER BY created_at DESC
        LIMIT 1
        FOR UPDATE
      `;

      if (!challenge || challenge.attempt_count >= 5) {
        throw new ApiError(401, 'OTP_INVALID', 'رمز التحقق غير صالح أو منتهي.');
      }

      if (challenge.code_hash !== this.hashOtp(phone, code)) {
        await transaction`
          UPDATE otp_challenges
          SET attempt_count = attempt_count + 1
          WHERE id = ${challenge.id}
        `;
        throw new ApiError(401, 'OTP_INVALID', 'رمز التحقق غير صالح أو منتهي.');
      }

      await transaction`
        UPDATE otp_challenges SET verified_at = now() WHERE id = ${challenge.id}
      `;

      const [existing] = await transaction<UserRow[]>`
        SELECT id, phone_e164, display_name
        FROM users
        WHERE phone_e164 = ${phone}
        LIMIT 1
        FOR UPDATE
      `;

      if (existing) return existing;

      const [created] = await transaction<UserRow[]>`
        INSERT INTO users (phone_e164)
        VALUES (${phone})
        RETURNING id, phone_e164, display_name
      `;

      if (!created) {
        throw new ApiError(500, 'USER_CREATION_FAILED', 'تعذر إنشاء حساب المستخدم.');
      }

      return created;
    });

    return this.createSession(user, deviceId);
  }

  async refresh(refreshToken: string, deviceId: string): Promise<AuthSession> {
    const tokenHash = this.hashToken(refreshToken);
    const rotation = await this.database.begin(async (transaction) => {
      const [session] = await transaction<{
        id: string;
        user_id: string;
      }[]>`
        SELECT id, user_id
        FROM refresh_sessions
        WHERE token_hash = ${tokenHash}
          AND device_id = ${deviceId}::uuid
          AND revoked_at IS NULL
          AND expires_at > now()
        LIMIT 1
        FOR UPDATE
      `;

      if (!session) {
        throw new ApiError(401, 'SESSION_INVALID', 'جلسة التجديد غير صالحة أو منتهية.');
      }

      const nextToken = this.newRefreshToken();
      const [nextSession] = await transaction<{ id: string }[]>`
        INSERT INTO refresh_sessions (user_id, device_id, token_hash, expires_at)
        VALUES (
          ${session.user_id}::uuid,
          ${deviceId}::uuid,
          ${this.hashToken(nextToken)},
          now() + (${this.config.REFRESH_TOKEN_TTL_SECONDS} * interval '1 second')
        )
        RETURNING id
      `;

      if (!nextSession) {
        throw new ApiError(500, 'SESSION_CREATION_FAILED', 'تعذر تجديد الجلسة.');
      }

      await transaction`
        UPDATE refresh_sessions
        SET revoked_at = now(), replaced_by_session_id = ${nextSession.id}::uuid, last_used_at = now()
        WHERE id = ${session.id}::uuid
      `;

      return { userId: session.user_id, refreshToken: nextToken };
    });

    const user = await this.requireUser(rotation.userId);
    return this.buildSession(user, deviceId, rotation.refreshToken);
  }

  async logout(refreshToken: string, deviceId: string): Promise<void> {
    await this.database`
      UPDATE refresh_sessions
      SET revoked_at = COALESCE(revoked_at, now())
      WHERE token_hash = ${this.hashToken(refreshToken)}
        AND device_id = ${deviceId}::uuid
    `;
  }

  async getProfile(userId: string): Promise<AuthSession['user'] & { organizations: AuthSession['organizations'] }> {
    const user = await this.requireUser(userId);
    const organizations = await this.getOrganizations(user.id);

    return {
      id: user.id,
      phone: user.phone_e164,
      displayName: user.display_name,
      organizations,
    };
  }

  private async createSession(user: UserRow, deviceId: string): Promise<AuthSession> {
    const refreshToken = this.newRefreshToken();

    await this.database`
      INSERT INTO refresh_sessions (user_id, device_id, token_hash, expires_at)
      VALUES (
        ${user.id}::uuid,
        ${deviceId}::uuid,
        ${this.hashToken(refreshToken)},
        now() + (${this.config.REFRESH_TOKEN_TTL_SECONDS} * interval '1 second')
      )
    `;

    return this.buildSession(user, deviceId, refreshToken);
  }

  private async buildSession(
    user: UserRow,
    deviceId: string,
    refreshToken: string,
  ): Promise<AuthSession> {
    const accessToken = this.app.jwt.sign(
      { sub: user.id, deviceId, kind: 'access' },
      { expiresIn: this.config.ACCESS_TOKEN_TTL_SECONDS },
    );
    const organizations = await this.getOrganizations(user.id);

    return {
      accessToken,
      refreshToken,
      accessTokenExpiresAt: new Date(
        Date.now() + this.config.ACCESS_TOKEN_TTL_SECONDS * 1000,
      ).toISOString(),
      user: {
        id: user.id,
        phone: user.phone_e164,
        displayName: user.display_name,
      },
      organizations,
    };
  }

  private async requireUser(userId: string): Promise<UserRow> {
    const [user] = await this.database<UserRow[]>`
      SELECT id, phone_e164, display_name
      FROM users
      WHERE id = ${userId}::uuid
      LIMIT 1
    `;

    if (!user) {
      throw new ApiError(401, 'USER_NOT_FOUND', 'المستخدم غير موجود.');
    }

    return user;
  }

  private async getOrganizations(userId: string): Promise<AuthSession['organizations']> {
    const memberships = await this.database<MembershipRow[]>`
      SELECT
        organizations.id,
        organizations.name,
        organizations.base_currency_code,
        organization_members.role
      FROM organization_members
      INNER JOIN organizations ON organizations.id = organization_members.organization_id
      WHERE organization_members.user_id = ${userId}::uuid
        AND organization_members.is_active = true
      ORDER BY organizations.created_at ASC
    `;

    return memberships.map((membership) => ({
      id: membership.id,
      name: membership.name,
      baseCurrencyCode: membership.base_currency_code,
      role: membership.role,
    }));
  }

  private hashOtp(phone: string, code: string): string {
    return createHash('sha256').update(`${phone}:${code}`).digest('hex');
  }

  private hashToken(token: string): string {
    return createHash('sha256').update(token).digest('hex');
  }

  private newRefreshToken(): string {
    return randomBytes(48).toString('base64url');
  }
}
