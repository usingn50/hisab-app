import { errorSchema, registry, z } from './common.js';

const phoneSchema = z
  .string()
  .regex(/^\+[1-9]\d{7,14}$/)
  .openapi('PhoneE164', { example: '+967712345678' });

const deviceIdSchema = z.string().uuid().openapi('DeviceId');

export const otpRequestSchema = z.object({
  phone: phoneSchema,
});

export const otpVerifySchema = z.object({
  phone: phoneSchema,
  code: z.string().regex(/^\d{6}$/),
  deviceId: deviceIdSchema,
});

export const refreshSchema = z.object({
  refreshToken: z.string().min(40),
  deviceId: deviceIdSchema,
});

export const logoutSchema = refreshSchema;

export const organizationMembershipSchema = z.object({
  id: z.string().uuid(),
  name: z.string(),
  baseCurrencyCode: z.string().length(3),
  role: z.enum(['owner', 'manager', 'cashier', 'accountant', 'viewer']),
});

export const authSessionSchema = registry.register(
  'AuthSession',
  z
    .object({
      accessToken: z.string(),
      refreshToken: z.string(),
      accessTokenExpiresAt: z.string().datetime(),
      user: z.object({
        id: z.string().uuid(),
        phone: phoneSchema,
        displayName: z.string().nullable(),
      }),
      organizations: z.array(organizationMembershipSchema),
    })
    .openapi('AuthSession'),
);

export const otpRequestResponseSchema = registry.register(
  'OtpRequestResponse',
  z
    .object({
      accepted: z.literal(true),
      expiresInSeconds: z.number().int().positive(),
    })
    .openapi('OtpRequestResponse'),
);

registry.registerPath({
  method: 'post',
  path: '/auth/otp/request',
  tags: ['Authentication'],
  operationId: 'requestOtp',
  summary: 'طلب رمز تحقق للهاتف',
  request: {
    body: {
      required: true,
      content: { 'application/json': { schema: otpRequestSchema } },
    },
  },
  responses: {
    '200': {
      description: 'تم قبول طلب الرمز.',
      content: { 'application/json': { schema: otpRequestResponseSchema } },
    },
    '422': {
      description: 'رقم الهاتف غير صالح.',
      content: { 'application/json': { schema: errorSchema } },
    },
    '429': {
      description: 'تجاوز المستخدم حد الطلبات.',
      content: { 'application/json': { schema: errorSchema } },
    },
  },
});

registry.registerPath({
  method: 'post',
  path: '/auth/otp/verify',
  tags: ['Authentication'],
  operationId: 'verifyOtp',
  summary: 'التحقق من رمز الهاتف وإنشاء جلسة',
  request: {
    body: {
      required: true,
      content: { 'application/json': { schema: otpVerifySchema } },
    },
  },
  responses: {
    '200': {
      description: 'تم التحقق وأنشئت الجلسة.',
      content: { 'application/json': { schema: authSessionSchema } },
    },
    '401': {
      description: 'الرمز غير صالح أو منتهي.',
      content: { 'application/json': { schema: errorSchema } },
    },
    '422': {
      description: 'بيانات الطلب غير صالحة.',
      content: { 'application/json': { schema: errorSchema } },
    },
  },
});

registry.registerPath({
  method: 'post',
  path: '/auth/refresh',
  tags: ['Authentication'],
  operationId: 'refreshSession',
  summary: 'تجديد جلسة الجهاز',
  request: {
    body: {
      required: true,
      content: { 'application/json': { schema: refreshSchema } },
    },
  },
  responses: {
    '200': {
      description: 'تم تدوير رموز الجلسة.',
      content: { 'application/json': { schema: authSessionSchema } },
    },
    '401': {
      description: 'جلسة التجديد غير صالحة.',
      content: { 'application/json': { schema: errorSchema } },
    },
  },
});

registry.registerPath({
  method: 'post',
  path: '/auth/logout',
  tags: ['Authentication'],
  operationId: 'logoutSession',
  summary: 'إبطال جلسة الجهاز',
  request: {
    body: {
      required: true,
      content: { 'application/json': { schema: logoutSchema } },
    },
  },
  responses: {
    '204': { description: 'أبطلت الجلسة.' },
    '422': {
      description: 'بيانات الطلب غير صالحة.',
      content: { 'application/json': { schema: errorSchema } },
    },
  },
});
