import 'dotenv/config';
import { z } from 'zod';

const environmentSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  HOST: z.string().default('0.0.0.0'),
  PORT: z.coerce.number().int().min(1).max(65535).default(8081),
  DATABASE_URL: z.string().url(),
  JWT_ACCESS_SECRET: z.string().min(32),
  JWT_REFRESH_SECRET: z.string().min(32),
  ACCESS_TOKEN_TTL_SECONDS: z.coerce.number().int().positive().default(900),
  REFRESH_TOKEN_TTL_SECONDS: z.coerce.number().int().positive().default(2592000),
  OTP_PROVIDER: z.enum(['development', 'twilio']).default('development'),
  OTP_DEVELOPMENT_CODE: z.string().min(6).optional(),
  TWILIO_ACCOUNT_SID: z.string().regex(/^AC[a-zA-Z0-9]{32}$/).optional(),
  TWILIO_AUTH_TOKEN: z.string().min(32).optional(),
  TWILIO_VERIFY_SERVICE_SID: z.string().regex(/^VA[a-zA-Z0-9]{32}$/).optional(),
  TWILIO_VERIFY_CHANNEL: z.enum(['sms', 'whatsapp']).default('sms'),
  CORS_ORIGIN: z.string().url().default('http://localhost:3000'),
});

export type AppConfig = z.infer<typeof environmentSchema>;

export function loadConfig(source: NodeJS.ProcessEnv = process.env): AppConfig {
  const parsed = environmentSchema.safeParse(source);
  if (!parsed.success) {
    throw new Error(`Invalid server configuration: ${parsed.error.message}`);
  }

  const config = parsed.data;
  if (config.NODE_ENV === 'production' && config.OTP_PROVIDER === 'development') {
    throw new Error('OTP_PROVIDER=development is not allowed in production.');
  }
  if (
    config.OTP_PROVIDER === 'twilio' &&
    (!config.TWILIO_ACCOUNT_SID ||
      !config.TWILIO_AUTH_TOKEN ||
      !config.TWILIO_VERIFY_SERVICE_SID)
  ) {
    throw new Error('Twilio Verify requires TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, and TWILIO_VERIFY_SERVICE_SID.');
  }

  return config;
}
