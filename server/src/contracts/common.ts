import {
  OpenAPIRegistry,
  extendZodWithOpenApi,
} from '@asteasolutions/zod-to-openapi';
import { z } from 'zod';

extendZodWithOpenApi(z);

export { z };
export const registry = new OpenAPIRegistry();

export const requestIdSchema = z
  .string()
  .uuid()
  .openapi('RequestId', { description: 'معرف طلب فريد للتتبع.' });

export const errorSchema = registry.register(
  'ApiError',
  z
    .object({
      error: z.object({
        code: z.string().min(1),
        message: z.string().min(1),
        requestId: requestIdSchema,
        details: z
          .array(
            z.object({
              field: z.string().min(1),
              reason: z.string().min(1),
            }),
          )
          .default([]),
      }),
    })
    .openapi('ApiError'),
);

export const healthResponseSchema = registry.register(
  'HealthResponse',
  z
    .object({
      status: z.literal('ok'),
      service: z.literal('hisab-api'),
      timestamp: z.string().datetime(),
    })
    .openapi('HealthResponse'),
);

export const bearerAuth = registry.registerComponent('securitySchemes', 'bearerAuth', {
  type: 'http',
  scheme: 'bearer',
  bearerFormat: 'JWT',
  description: 'رمز وصول قصير العمر صادر عن خدمة حساب.',
});
