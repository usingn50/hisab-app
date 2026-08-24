import { ApiError } from '../../core/api-error.js';
import type { DatabaseClient } from '../../db/client.js';

type MemberRole = 'owner' | 'manager' | 'cashier' | 'accountant' | 'viewer';

type OrganizationRow = {
  id: string;
  name: string;
  base_currency_code: string;
  timezone: string;
  role: MemberRole;
};

type BranchRow = {
  id: string;
  name: string;
  city: string | null;
  is_active: boolean;
};

type MembershipRow = {
  id: string;
  role: MemberRole;
};

type CreateOrganizationInput = {
  name: string;
  baseCurrencyCode: 'YER' | 'USD' | 'SAR';
  timezone: string;
  initialBranchName: string;
  city?: string | undefined;
};

type AddMemberInput = {
  phone: string;
  role: Exclude<MemberRole, 'owner'>;
};

export class OrganizationService {
  constructor(private readonly database: DatabaseClient) {}

  async listForUser(userId: string) {
    const rows = await this.database<OrganizationRow[]>`
      SELECT
        organizations.id,
        organizations.name,
        organizations.base_currency_code,
        organizations.timezone,
        organization_members.role
      FROM organization_members
      INNER JOIN organizations ON organizations.id = organization_members.organization_id
      WHERE organization_members.user_id = ${userId}::uuid
        AND organization_members.is_active = true
      ORDER BY organizations.created_at ASC
    `;

    return rows.map((row) => this.toOrganization(row));
  }

  async create(userId: string, input: CreateOrganizationInput) {
    const organization = await this.database.begin(async (transaction) => {
      const [created] = await transaction<OrganizationRow[]>`
        INSERT INTO organizations (name, base_currency_code, timezone)
        VALUES (${input.name}, ${input.baseCurrencyCode}, ${input.timezone})
        RETURNING id, name, base_currency_code, timezone, 'owner'::member_role AS role
      `;

      if (!created) {
        throw new ApiError(500, 'ORGANIZATION_CREATION_FAILED', 'تعذر إنشاء المؤسسة.');
      }

      await transaction`
        INSERT INTO organization_members (organization_id, user_id, role)
        VALUES (${created.id}::uuid, ${userId}::uuid, 'owner')
      `;

      await transaction`
        INSERT INTO branches (organization_id, name, city)
        VALUES (${created.id}::uuid, ${input.initialBranchName}, ${input.city ?? null})
      `;

      await transaction`
        INSERT INTO audit_events (organization_id, actor_user_id, action, entity_type, entity_id, after_data)
        VALUES (
          ${created.id}::uuid,
          ${userId}::uuid,
          'organization.created',
          'organization',
          ${created.id}::uuid,
          ${JSON.stringify({ name: input.name, baseCurrencyCode: input.baseCurrencyCode })}::jsonb
        )
      `;

      return created;
    });

    return this.toOrganization(organization);
  }

  async listBranches(userId: string, organizationId: string) {
    await this.requireMembership(userId, organizationId);

    const branches = await this.database<BranchRow[]>`
      SELECT id, name, city, is_active
      FROM branches
      WHERE organization_id = ${organizationId}::uuid
      ORDER BY created_at ASC
    `;

    return branches.map((branch) => ({
      id: branch.id,
      name: branch.name,
      city: branch.city,
      isActive: branch.is_active,
    }));
  }

  async addMember(userId: string, organizationId: string, input: AddMemberInput) {
    const actor = await this.requireMembership(userId, organizationId);
    if (!['owner', 'manager'].includes(actor.role)) {
      throw new ApiError(403, 'MEMBER_MANAGEMENT_DENIED', 'لا تملك صلاحية إدارة أعضاء المؤسسة.');
    }
    if (actor.role === 'manager' && input.role === 'manager') {
      throw new ApiError(403, 'MEMBER_ROLE_DENIED', 'المدير لا يستطيع إضافة مدير آخر.');
    }

    const [targetUser] = await this.database<{ id: string }[]>`
      SELECT id FROM users WHERE phone_e164 = ${input.phone} LIMIT 1
    `;
    if (!targetUser) {
      throw new ApiError(409, 'USER_NOT_REGISTERED', 'يجب أن يتحقق المستخدم من رقم هاتفه قبل إضافته.');
    }

    const member = await this.database.begin(async (transaction) => {
      const [upserted] = await transaction<{
        id: string;
        user_id: string;
        role: MemberRole;
        is_active: boolean;
      }[]>`
        INSERT INTO organization_members (organization_id, user_id, role, is_active)
        VALUES (${organizationId}::uuid, ${targetUser.id}::uuid, ${input.role}::member_role, true)
        ON CONFLICT (organization_id, user_id)
        DO UPDATE SET role = EXCLUDED.role, is_active = true, updated_at = now()
        RETURNING id, user_id, role, is_active
      `;

      if (!upserted) {
        throw new ApiError(500, 'MEMBER_CREATION_FAILED', 'تعذر إضافة عضو المؤسسة.');
      }

      await transaction`
        INSERT INTO audit_events (organization_id, actor_user_id, action, entity_type, entity_id, after_data)
        VALUES (
          ${organizationId}::uuid,
          ${userId}::uuid,
          'organization.member.upserted',
          'organization_member',
          ${upserted.id}::uuid,
          ${JSON.stringify({ userId: targetUser.id, role: input.role })}::jsonb
        )
      `;

      return upserted;
    });

    return {
      id: member.id,
      userId: member.user_id,
      phone: input.phone,
      role: member.role,
      isActive: member.is_active,
    };
  }

  async requireRole(
    userId: string,
    organizationId: string,
    allowedRoles: MemberRole[],
  ): Promise<MemberRole> {
    const membership = await this.requireMembership(userId, organizationId);
    if (!allowedRoles.includes(membership.role)) {
      throw new ApiError(403, 'ORGANIZATION_ROLE_DENIED', 'لا تملك صلاحية تنفيذ هذا الإجراء.');
    }
    return membership.role;
  }

  private async requireMembership(userId: string, organizationId: string): Promise<MembershipRow> {
    const [membership] = await this.database<MembershipRow[]>`
      SELECT id, role
      FROM organization_members
      WHERE organization_id = ${organizationId}::uuid
        AND user_id = ${userId}::uuid
        AND is_active = true
      LIMIT 1
    `;

    if (!membership) {
      throw new ApiError(403, 'ORGANIZATION_ACCESS_DENIED', 'لا تملك صلاحية الوصول إلى هذه المؤسسة.');
    }

    return membership;
  }

  private toOrganization(row: OrganizationRow) {
    return {
      id: row.id,
      name: row.name,
      baseCurrencyCode: row.base_currency_code,
      timezone: row.timezone,
      role: row.role,
    };
  }
}
