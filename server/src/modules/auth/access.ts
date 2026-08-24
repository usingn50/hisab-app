import type { FastifyRequest } from 'fastify';

import { ApiError } from '../../core/api-error.js';

export type AccessTokenPayload = {
  sub: string;
  deviceId: string;
  kind: 'access';
};

export async function requireAccessToken(
  request: FastifyRequest,
): Promise<AccessTokenPayload> {
  try {
    const payload = await request.jwtVerify<AccessTokenPayload>();

    if (payload.kind !== 'access' || !payload.sub) {
      throw new ApiError(401, 'ACCESS_TOKEN_INVALID', 'رمز الوصول غير صالح.');
    }

    return payload;
  } catch (error) {
    if (error instanceof ApiError) throw error;
    throw new ApiError(401, 'ACCESS_TOKEN_INVALID', 'رمز الوصول غير صالح.');
  }
}
