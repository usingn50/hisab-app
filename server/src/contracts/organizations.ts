import { bearerAuth, errorSchema, registry, z } from './common.js';

export const organizationIdSchema = z.string().uuid().openapi('OrganizationId');

export const createOrganizationSchema = z.object({
  name: z.string().trim().min(2).max(120),
  baseCurrencyCode: z.enum(['YER', 'USD', 'SAR']).default('YER'),
  timezone: z.string().min(1).max(80).default('Asia/Aden'),
  initialBranchName: z.string().trim().min(2).max(120).default('الفرع الرئيسي'),
  city: z.string().trim().min(1).max(120).optional(),
});

export const organizationSchema = registry.register(
  'Organization',
  z
    .object({
      id: organizationIdSchema,
      name: z.string(),
      baseCurrencyCode: z.string().length(3),
      timezone: z.string(),
      role: z.enum(['owner', 'manager', 'cashier', 'accountant', 'viewer']),
    })
    .openapi('Organization'),
);

export const branchSchema = registry.register(
  'Branch',
  z
    .object({
      id: z.string().uuid(),
      name: z.string(),
      city: z.string().nullable(),
      isActive: z.boolean(),
    })
    .openapi('Branch'),
);

registry.registerPath({
  method: 'get',
  path: '/organizations',
  tags: ['Organizations'],
  operationId: 'listOrganizations',
  summary: 'قراءة المؤسسات التي ينتمي إليها المستخدم',
  security: [{ bearerAuth: [] }],
  responses: {
    '200': {
      description: 'المؤسسات المتاحة للمستخدم.',
      content: { 'application/json': { schema: z.array(organizationSchema) } },
    },
    '401': {
      description: 'رمز الوصول غير صالح.',
      content: { 'application/json': { schema: errorSchema } },
    },
  },
});

registry.registerPath({
  method: 'post',
  path: '/organizations',
  tags: ['Organizations'],
  operationId: 'createOrganization',
  summary: 'إنشاء مؤسسة مع فرعها الرئيسي',
  security: [{ bearerAuth: [] }],
  request: {
    body: {
      required: true,
      content: { 'application/json': { schema: createOrganizationSchema } },
    },
  },
  responses: {
    '201': {
      description: 'أنشئت المؤسسة وعضوية المالك والفرع الرئيسي.',
      content: { 'application/json': { schema: organizationSchema } },
    },
    '401': {
      description: 'رمز الوصول غير صالح.',
      content: { 'application/json': { schema: errorSchema } },
    },
    '422': {
      description: 'بيانات المؤسسة غير صالحة.',
      content: { 'application/json': { schema: errorSchema } },
    },
  },
});

registry.registerPath({
  method: 'get',
  path: '/organizations/{organizationId}/branches',
  tags: ['Organizations'],
  operationId: 'listBranches',
  summary: 'قراءة فروع مؤسسة مسموح بها للمستخدم',
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ organizationId: organizationIdSchema }),
  },
  responses: {
    '200': {
      description: 'فروع المؤسسة.',
      content: { 'application/json': { schema: z.array(branchSchema) } },
    },
    '401': {
      description: 'رمز الوصول غير صالح.',
      content: { 'application/json': { schema: errorSchema } },
    },
    '403': {
      description: 'المستخدم لا ينتمي إلى المؤسسة.',
      content: { 'application/json': { schema: errorSchema } },
    },
  },
});

export const addOrganizationMemberSchema = z.object({
  phone: z.string().regex(/^\+[1-9]\d{7,14}$/),
  role: z.enum(['manager', 'cashier', 'accountant', 'viewer']),
});

export const organizationMemberSchema = registry.register(
  'OrganizationMember',
  z
    .object({
      id: z.string().uuid(),
      userId: z.string().uuid(),
      phone: z.string(),
      role: z.enum(['owner', 'manager', 'cashier', 'accountant', 'viewer']),
      isActive: z.boolean(),
    })
    .openapi('OrganizationMember'),
);

registry.registerPath({
  method: 'post',
  path: '/organizations/{organizationId}/members',
  tags: ['Organizations'],
  operationId: 'addOrganizationMember',
  summary: 'إضافة عضو مسجل إلى مؤسسة',
  security: [{ bearerAuth: [] }],
  request: {
    params: z.object({ organizationId: organizationIdSchema }),
    body: {
      required: true,
      content: { 'application/json': { schema: addOrganizationMemberSchema } },
    },
  },
  responses: {
    '201': {
      description: 'أضيف العضو أو أعيد تفعيل عضويته.',
      content: { 'application/json': { schema: organizationMemberSchema } },
    },
    '401': {
      description: 'رمز الوصول غير صالح.',
      content: { 'application/json': { schema: errorSchema } },
    },
    '403': {
      description: 'الدور الحالي لا يسمح بإدارة الأعضاء.',
      content: { 'application/json': { schema: errorSchema } },
    },
    '409': {
      description: 'المستخدم غير مسجل بعد أو العضوية موجودة.',
      content: { 'application/json': { schema: errorSchema } },
    },
    '422': {
      description: 'بيانات العضو غير صالحة.',
      content: { 'application/json': { schema: errorSchema } },
    },
  },
});
