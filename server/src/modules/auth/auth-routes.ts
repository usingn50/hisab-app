import type { FastifyInstance } from 'fastify';

import {
  logoutSchema,
  otpRequestSchema,
  otpVerifySchema,
  refreshSchema,
} from '../../contracts/auth.js';
import { requireAccessToken } from './access.js';
import type { AuthService } from './auth-service.js';

export async function registerAuthRoutes(
  app: FastifyInstance,
  authService: AuthService,
): Promise<void> {
  app.post('/auth/otp/request', async (request) => {
    const payload = otpRequestSchema.parse(request.body);
    return authService.requestOtp(payload.phone);
  });

  app.post('/auth/otp/verify', async (request) => {
    const payload = otpVerifySchema.parse(request.body);
    return authService.verifyOtp(payload.phone, payload.code, payload.deviceId);
  });

  app.post('/auth/refresh', async (request) => {
    const payload = refreshSchema.parse(request.body);
    return authService.refresh(payload.refreshToken, payload.deviceId);
  });

  app.post('/auth/logout', async (request, reply) => {
    const payload = logoutSchema.parse(request.body);
    await authService.logout(payload.refreshToken, payload.deviceId);
    return reply.status(204).send();
  });

  app.get('/me', async (request) => {
    const payload = await requireAccessToken(request);
    return authService.getProfile(payload.sub);
  });
}
