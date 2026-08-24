import { bearerAuth, errorSchema, registry, z } from './common.js';
import { organizationIdSchema } from './organizations.js';

const productIdSchema = z.string().uuid().openapi('ProductId');
const branchIdSchema = z.string().uuid().openapi('BranchId');

export const createProductSchema = z.object({
  name: z.string().trim().min(1).max(200),
  sku: z.string().trim().min(1).max(100).optional(),
  barcode: z.string().trim().min(1).max(100).optional(),
  sellPriceMinor: z.number().int().nonnegative(),
  currencyCode: z.enum(['YER', 'USD', 'SAR']),
  minStockQuantity: z.number().int().nonnegative().default(0),
});

export const stockAdjustmentSchema = z.object({
  branchId: branchIdSchema,
  quantityDelta: z.number().int().refine((value) => value !== 0),
  reason: z.literal('adjustment'),
});

export const productSchema = registry.register(
  'Product',
  z
    .object({
      id: productIdSchema,
      name: z.string(),
      sku: z.string().nullable(),
      barcode: z.string().nullable(),
      sellPriceMinor: z.number().int().nonnegative(),
      currencyCode: z.string().length(3),
      minStockQuantity: z.number().int().nonnegative(),
      isActive: z.boolean(),
      version: z.string(),
    })
    .openapi('Product'),
);

registry.registerPath({
  method: 'get',
  path: '/organizations/{organizationId}/products',
  tags: ['Catalog'],
  operationId: 'listProducts',
  summary: 'قراءة منتجات مؤسسة',
  security: [{ bearerAuth: [] }],
  request: { params: z.object({ organizationId: organizationIdSchema }) },
  responses: {
    '200': {
      description: 'المنتجات النشطة.',
      content: { 'application/json': { schema: z.array(productSchema) } },
    },
    '401': { description: 'رمز الوصول غير صالح.', content: { 'application/json': { schema: errorSchema } } },
    '403': { description: 'لا توجد عضوية فعالة.', content: { 'application/json': { schema: errorSchema } } },
  },
});

registry.registerPath({
  method: 'post',
  path: '/organizations/{organizationId}/products',
  tags: ['Catalog'],
  operationId: 'createProduct',
  summary: 'إنشاء منتج',
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ organizationId: organizationIdSchema }),
    body: { required: true, content: { 'application/json': { schema: createProductSchema } } },
  },
  responses: {
    '201': { description: 'أنشئ المنتج.', content: { 'application/json': { schema: productSchema } } },
    '401': { description: 'رمز الوصول غير صالح.', content: { 'application/json': { schema: errorSchema } } },
    '403': { description: 'الدور لا يسمح بإدارة المنتجات.', content: { 'application/json': { schema: errorSchema } } },
    '409': { description: 'الباركود أو SKU مستخدم.', content: { 'application/json': { schema: errorSchema } } },
    '422': { description: 'بيانات المنتج غير صالحة.', content: { 'application/json': { schema: errorSchema } } },
  },
});

registry.registerPath({
  method: 'post',
  path: '/organizations/{organizationId}/products/{productId}/stock-adjustments',
  tags: ['Inventory'],
  operationId: 'recordStockAdjustment',
  summary: 'تسجيل تسوية مخزون مبررة',
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ organizationId: organizationIdSchema, productId: productIdSchema }),
    body: { required: true, content: { 'application/json': { schema: stockAdjustmentSchema } } },
  },
  responses: {
    '204': { description: 'سجلت التسوية.' },
    '401': { description: 'رمز الوصول غير صالح.', content: { 'application/json': { schema: errorSchema } } },
    '403': { description: 'الدور لا يسمح بتسوية المخزون.', content: { 'application/json': { schema: errorSchema } } },
    '409': { description: 'التسوية ستنتج رصيداً سالباً.', content: { 'application/json': { schema: errorSchema } } },
    '422': { description: 'بيانات التسوية غير صالحة.', content: { 'application/json': { schema: errorSchema } } },
  },
});
