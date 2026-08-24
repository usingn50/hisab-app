import { createHash } from 'node:crypto';

import type { AppConfig } from '../../config.js';
import { ApiError } from '../../core/api-error.js';

export type OtpRequest = {
  reference: string | null;
  expiresInSeconds: number;
};

export interface OtpProvider {
  request(phone: string): Promise<OtpRequest>;
  verify(phone: string, code: string, reference: string | null): Promise<boolean>;
}

export function createOtpProvider(config: AppConfig): OtpProvider {
  if (config.OTP_PROVIDER === 'development') {
    return new DevelopmentOtpProvider(config.OTP_DEVELOPMENT_CODE);
  }
  if (
    !config.TWILIO_ACCOUNT_SID ||
    !config.TWILIO_AUTH_TOKEN ||
    !config.TWILIO_VERIFY_SERVICE_SID
  ) {
    throw new Error('Twilio Verify configuration is incomplete.');
  }
  return new TwilioVerifyOtpProvider({
    accountSid: config.TWILIO_ACCOUNT_SID,
    authToken: config.TWILIO_AUTH_TOKEN,
    serviceSid: config.TWILIO_VERIFY_SERVICE_SID,
    channel: config.TWILIO_VERIFY_CHANNEL,
  });
}

class DevelopmentOtpProvider implements OtpProvider {
  constructor(private readonly code: string | undefined) {}

  async request(phone: string): Promise<OtpRequest> {
    if (!this.code) {
      throw new ApiError(500, 'OTP_CONFIGURATION_ERROR', 'إعداد التحقق غير مكتمل.');
    }
    return { reference: null, expiresInSeconds: 600 };
  }

  async verify(phone: string, code: string): Promise<boolean> {
    if (!this.code) return false;
    return this.hash(phone, code) === this.hash(phone, this.code);
  }

  private hash(phone: string, code: string): string {
    return createHash('sha256').update(`${phone}:${code}`).digest('hex');
  }
}

type TwilioVerifyOptions = {
  accountSid: string;
  authToken: string;
  serviceSid: string;
  channel: 'sms' | 'whatsapp';
};

class TwilioVerifyOtpProvider implements OtpProvider {
  constructor(private readonly options: TwilioVerifyOptions) {}

  async request(phone: string): Promise<OtpRequest> {
    const response = await this.requestTwilio('Verifications', {
      To: phone,
      Channel: this.options.channel,
    });
    const payload = (await response.json()) as { sid?: string };
    if (!payload.sid) {
      throw new ApiError(503, 'OTP_DELIVERY_FAILED', 'تعذر إرسال رمز التحقق.');
    }
    return { reference: payload.sid, expiresInSeconds: 600 };
  }

  async verify(phone: string, code: string): Promise<boolean> {
    const response = await this.requestTwilio('VerificationCheck', {
      To: phone,
      Code: code,
    });
    const payload = (await response.json()) as { status?: string; valid?: boolean };
    return payload.status === 'approved' || payload.valid === true;
  }

  private async requestTwilio(
    resource: 'Verifications' | 'VerificationCheck',
    form: Record<string, string>,
  ): Promise<Response> {
    let response: Response;
    try {
      response = await fetch(
        `https://verify.twilio.com/v2/Services/${this.options.serviceSid}/${resource}`,
        {
          method: 'POST',
          headers: {
            Authorization: `Basic ${Buffer.from(
              `${this.options.accountSid}:${this.options.authToken}`,
            ).toString('base64')}`,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: new URLSearchParams(form),
          signal: AbortSignal.timeout(10000),
        },
      );
    } catch {
      throw new ApiError(503, 'OTP_PROVIDER_UNAVAILABLE', 'مزود التحقق غير متاح حالياً.');
    }

    if (!response.ok) {
      throw new ApiError(503, 'OTP_DELIVERY_FAILED', 'تعذر إرسال رمز التحقق.');
    }
    return response;
  }
}
