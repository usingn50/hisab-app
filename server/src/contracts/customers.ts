import { bearerAuth, errorSchema, registry, z } from './common.js';
import { organizationIdSchema } from './organizations.js';

const customerIdSchema = z.string().uuid().openapi('CustomerId');

export const createCustomerSchema = z.object({
  name: z.string().trim().min(1).max(200),
  phone: z.string().regex(/^\+[1-9]\d{7,14}$/).optional(),
  creditLimitMinor: z.number().int().nonnegative().optional(),
});

export const customerSchema = registry.register(
  'Customer',
  z
    .object({
      id: customerIdSchema,
      name: z.string(),
      phone: z.string().nullable(),
      creditLimitMinor: z.number().int().nonnegative().nullable(),
      version: z.string(),
    })
    .openapi('Customer'),
);

registry.registerPath({
  method: 'get',
  path: '/organizations/{organizationId}/customers',
  tags: ['Customers'],
  operationId: 'listCustomers',
  summary: 'قراءة عملاء المؤسسة',
  security: [{ bearerAuth: [] }],
  request: { params: z.object({ organizationId: organizationIdSchema }) },
  responses: {
    '200': { description: 'العملاء النشطون.', content: { 'application/json': { schema: z.array(customerSchema) } } },
    '401': { description: 'رمز الوصول غير صالح.', content: { 'application/json': { schema: errorSchema } } },
    '403': { description: 'لا توجد عضوية فعالة.', content: { 'application/json': { schema: errorSchema } } },
  },
});

registry.registerPath({
  method: 'post',
  path: '/organizations/{organizationId}/customers',
  tags: ['Customers'],
  operationId: 'createCustomer',
  summary: 'إنشاء عميل',
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ organizationId: organizationIdSchema }),
    body: { required: true, content: { 'application/json': { schema: createCustomerSchema } } },
  },
  responses: {
    '201': { description: 'أنشئ العميل.', content: { 'application/json': { schema: customerSchema } } },
    '401': { description: 'رمز الوصول غير صالح.', content: { 'application/json': { schema: errorSchema } } },
    '403': { description: 'الدور لا يسمح بإدارة العملاء.', content: { 'application/json': { schema: errorSchema } } },
    '422': { description: 'بيانات العميل غير صالحة.', content: { 'application/json': { schema: errorSchema } } },
  },
});

export const recordCustomerPaymentSchema = z.object({
  method: z.enum(['cash', 'bank_transfer', 'wallet']),
  amountMinor: z.number().int().positive(),
  currencyCode: z.enum(['YER', 'USD', 'SAR']),
  exchangeRate: z.string().regex(/^\d+(\.\d{1,12})?$/),
});

export const customerPaymentSchema = registry.register(
  'CustomerPayment',
  z
    .object({
      id: z.string().uuid(),
      customerId: customerIdSchema,
      amountMinor: z.number().int().positive(),
      baseAmountMinor: z.number().int().positive(),
      currencyCode: z.string().length(3),
      receivedAt: z.string().datetime(),
    })
    .openapi('CustomerPayment'),
);

registry.registerPath({
  method: 'post',
  path: '/organizations/{organizationId}/customers/{customerId}/payments',
  tags: ['Customers'],
  operationId: 'recordCustomerPayment',
  summary: 'تسجيل سداد دين عميل',
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ organizationId: organizationIdSchema, customerId: customerIdSchema }),
    body: { required: true, content: { 'application/json': { schema: recordCustomerPaymentSchema } } },
  },
  responses: {
    '201': { description: 'سجل السداد وقيد الدفتر.', content: { 'application/json': { schema: customerPaymentSchema } } },
    '401': { description: 'رمز الوصول غير صالح.', content: { 'application/json': { schema: errorSchema } } },
    '403': { description: 'الدور لا يسمح بتسجيل السداد.', content: { 'application/json': { schema: errorSchema } } },
    '409': { description: 'لا يوجد دين كافٍ للسداد أو تجاوز السداد الرصيد.', content: { 'application/json': { schema: errorSchema } } },
    '422': { description: 'بيانات السداد غير صالحة.', content: { 'application/json': { schema: errorSchema } } },
  },
});
