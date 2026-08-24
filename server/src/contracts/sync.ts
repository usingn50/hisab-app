import { bearerAuth, errorSchema, registry, z } from './common.js';
import { organizationIdSchema } from './organizations.js';

const cursorSchema = z.string().regex(/^\d+$/).openapi('SyncCursor');
const deviceIdSchema = z.string().uuid().openapi('DeviceId');

export const createCustomerMutationSchema = z.object({
  operation: z.literal('customer.create'),
  entityId: z.string().uuid(),
  payload: z.object({
    name: z.string().trim().min(1).max(200),
    phone: z.string().regex(/^\+[1-9]\d{7,14}$/).optional(),
    creditLimitMinor: z.number().int().nonnegative().optional(),
  }),
});

export const createProductMutationSchema = z.object({
  operation: z.literal('product.create'),
  entityId: z.string().uuid(),
  payload: z.object({
    name: z.string().trim().min(1).max(200),
    sku: z.string().trim().min(1).max(100).optional(),
    barcode: z.string().trim().min(1).max(100).optional(),
    sellPriceMinor: z.number().int().nonnegative(),
    currencyCode: z.enum(['YER', 'USD', 'SAR']),
    minStockQuantity: z.number().int().nonnegative().default(0),
  }),
});

const mutationOperationSchema = z.discriminatedUnion('operation', [
  createCustomerMutationSchema,
  createProductMutationSchema,
]);

export const pushMutationsSchema = z.object({
  deviceId: deviceIdSchema,
  mutations: z
    .array(
      z.object({
        mutationId: z.string().uuid(),
        clientCreatedAt: z.string().datetime(),
        operation: z.enum(['customer.create', 'product.create']),
        entityId: z.string().uuid(),
        payload: z.unknown(),
      }),
    )
    .min(1)
    .max(50),
});

export const pullChangesQuerySchema = z.object({
  cursor: cursorSchema.default('0'),
  limit: z.coerce.number().int().min(1).max(500).default(200),
});

export const mutationResultSchema = registry.register(
  'SyncMutationResult',
  z
    .object({
      mutationId: z.string().uuid(),
      status: z.enum(['applied', 'duplicate', 'conflict', 'rejected']),
      entityType: z.string(),
      entityId: z.string().uuid(),
      version: z.string().nullable(),
      error: z
        .object({
          code: z.string(),
          message: z.string(),
        })
        .nullable(),
    })
    .openapi('SyncMutationResult'),
);

export const syncChangeSchema = registry.register(
  'SyncChange',
  z
    .object({
      sequence: cursorSchema,
      entityType: z.string(),
      entityId: z.string().uuid(),
      operation: z.enum(['upsert', 'tombstone']),
      version: z.string(),
      payload: z.record(z.string(), z.unknown()),
      changedAt: z.string().datetime(),
    })
    .openapi('SyncChange'),
);

export const bootstrapResponseSchema = registry.register(
  'SyncBootstrap',
  z
    .object({
      snapshotId: z.string().uuid(),
      highWatermarkCursor: cursorSchema,
      branches: z.array(z.record(z.string(), z.unknown())),
      products: z.array(z.record(z.string(), z.unknown())),
      customers: z.array(z.record(z.string(), z.unknown())),
    })
    .openapi('SyncBootstrap'),
);

registry.registerPath({
  method: 'post',
  path: '/organizations/{organizationId}/sync/mutations',
  tags: ['Sync'],
  operationId: 'pushSyncMutations',
  summary: 'رفع أوامر محلية مع منع التكرار التجاري',
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ organizationId: organizationIdSchema }),
    body: { required: true, content: { 'application/json': { schema: pushMutationsSchema } } },
  },
  responses: {
    '200': {
      description: 'نتيجة مستقلة لكل أمر مرفوع.',
      content: { 'application/json': { schema: z.object({ results: z.array(mutationResultSchema) }) } },
    },
    '401': { description: 'رمز الوصول غير صالح.', content: { 'application/json': { schema: errorSchema } } },
    '403': { description: 'لا توجد عضوية فعالة.', content: { 'application/json': { schema: errorSchema } } },
    '422': { description: 'رسالة المزامنة غير صالحة.', content: { 'application/json': { schema: errorSchema } } },
  },
});

registry.registerPath({
  method: 'get',
  path: '/organizations/{organizationId}/sync/changes',
  tags: ['Sync'],
  operationId: 'pullSyncChanges',
  summary: 'تنزيل تغييرات المؤسسة بعد Cursor محدد',
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ organizationId: organizationIdSchema }),
    query: pullChangesQuerySchema,
  },
  responses: {
    '200': {
      description: 'صفحة تغييرات مرتبة من الخادم.',
      content: {
        'application/json': {
          schema: z.object({
            changes: z.array(syncChangeSchema),
            nextCursor: cursorSchema,
            hasMore: z.boolean(),
          }),
        },
      },
    },
    '401': { description: 'رمز الوصول غير صالح.', content: { 'application/json': { schema: errorSchema } } },
    '403': { description: 'لا توجد عضوية فعالة.', content: { 'application/json': { schema: errorSchema } } },
  },
});

registry.registerPath({
  method: 'post',
  path: '/organizations/{organizationId}/sync/bootstrap',
  tags: ['Sync'],
  operationId: 'bootstrapSyncScope',
  summary: 'إنشاء لقطة أولية لجهاز جديد',
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ organizationId: organizationIdSchema }),
    body: { required: true, content: { 'application/json': { schema: z.object({ deviceId: deviceIdSchema }) } } },
  },
  responses: {
    '200': { description: 'لقطة أولية مع أعلى Cursor ثابت.', content: { 'application/json': { schema: bootstrapResponseSchema } } },
    '401': { description: 'رمز الوصول غير صالح.', content: { 'application/json': { schema: errorSchema } } },
    '403': { description: 'لا توجد عضوية فعالة.', content: { 'application/json': { schema: errorSchema } } },
  },
});
