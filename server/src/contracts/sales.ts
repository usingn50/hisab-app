import { bearerAuth, errorSchema, registry, z } from './common.js';
import { organizationIdSchema } from './organizations.js';

const invoiceIdSchema = z.string().uuid().openapi('InvoiceId');
const branchIdSchema = z.string().uuid().openapi('BranchId');
const productIdSchema = z.string().uuid().openapi('ProductId');
const customerIdSchema = z.string().uuid().openapi('CustomerId');

const invoiceLineSchema = z.object({
  productId: productIdSchema,
  quantity: z.number().int().positive(),
  unitPriceMinor: z.number().int().nonnegative(),
});

const paymentSchema = z.object({
  method: z.enum(['cash', 'credit', 'bank_transfer', 'wallet']),
  amountMinor: z.number().int().nonnegative(),
});

export const issueInvoiceSchema = z
  .object({
    branchId: branchIdSchema,
    customerId: customerIdSchema.optional(),
    currencyCode: z.enum(['YER', 'USD', 'SAR']),
    exchangeRate: z.string().regex(/^\d+(\.\d{1,12})?$/),
    lines: z.array(invoiceLineSchema).min(1).max(100),
    payment: paymentSchema,
  })
  .superRefine((value, context) => {
    if (value.payment.method === 'credit' && value.payment.amountMinor !== 0) {
      context.addIssue({
        code: 'custom',
        path: ['payment', 'amountMinor'],
        message: 'البيع الآجل لا يحتوي مبلغاً مستلماً.',
      });
    }
  });

export const invoiceSchema = registry.register(
  'Invoice',
  z
    .object({
      id: invoiceIdSchema,
      status: z.literal('issued'),
      branchId: branchIdSchema,
      customerId: customerIdSchema.nullable(),
      currencyCode: z.string().length(3),
      exchangeRate: z.string(),
      totalMinor: z.number().int().nonnegative(),
      baseTotalMinor: z.number().int().nonnegative(),
      outstandingBaseMinor: z.number().int().nonnegative(),
      issuedAt: z.string().datetime(),
    })
    .openapi('Invoice'),
);

registry.registerPath({
  method: 'post',
  path: '/organizations/{organizationId}/invoices/issue',
  tags: ['Sales'],
  operationId: 'issueInvoice',
  summary: 'إصدار فاتورة وخصم المخزون وتسجيل الدفع أو الدين في معاملة واحدة',
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ organizationId: organizationIdSchema }),
    body: { required: true, content: { 'application/json': { schema: issueInvoiceSchema } } },
  },
  responses: {
    '201': { description: 'أصدرت الفاتورة.', content: { 'application/json': { schema: invoiceSchema } } },
    '401': { description: 'رمز الوصول غير صالح.', content: { 'application/json': { schema: errorSchema } } },
    '403': { description: 'الدور لا يسمح بإصدار فاتورة.', content: { 'application/json': { schema: errorSchema } } },
    '409': { description: 'لا يكفي المخزون أو تغيرت بيانات المنتج.', content: { 'application/json': { schema: errorSchema } } },
    '422': { description: 'بيانات الفاتورة أو الدفع غير صالحة.', content: { 'application/json': { schema: errorSchema } } },
  },
});
