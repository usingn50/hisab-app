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
  OTP_PROVIDER: z.enum(['development', 'provider']).default('development'),
  OTP_DEVELOPMENT_CODE: z.string().min(6).optional(),
  CORS_ORIGIN: z.string().url().default('http://localhost:3000'),
});

export type AppConfig = z.infer<typeof environmentSchema>;

export function loadConfig(source: NodeJS.ProcessEnv = process.env): AppConfig {
  const parsed = environmentSchema.safeParse(source);

  if (!parsed.success) {
    throw new Error(`Invalid server configuration: ${parsed.error.message}`);
  }

  if (
    parsed.data.NODE_ENV === 'production' &&
    parsed.data.OTP_PROVIDER === 'development'
  ) {
    throw new Error('OTP_PROVIDER=development is not allowed in production.');
  }

  return parsed.data;
}
