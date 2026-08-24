import { OpenApiGeneratorV31 } from '@asteasolutions/zod-to-openapi';
import type { OpenAPIObject } from 'openapi3-ts/oas31';

import '../contracts/auth.js';
import '../contracts/catalog.js';
import '../contracts/customers.js';
import '../contracts/organizations.js';
import '../contracts/sales.js';
import '../contracts/sync.js';
import {
  errorSchema,
  healthResponseSchema,
  registry,
} from '../contracts/common.js';

registry.registerPath({
  method: 'get',
  path: '/health',
  tags: ['System'],
  operationId: 'getHealth',
  summary: 'فحص صحة خدمة حساب',
  security: [],
  responses: {
    '200': {
      description: 'الخدمة تعمل.',
      content: {
        'application/json': { schema: healthResponseSchema },
      },
    },
    '429': {
      description: 'تجاوز حد الطلبات المسموح.',
      content: {
        'application/json': { schema: errorSchema },
      },
    },
    '500': {
      description: 'تعذر التحقق من صحة الخدمة.',
      content: {
        'application/json': { schema: errorSchema },
      },
    },
  },
});

export function buildOpenApiDocument(): OpenAPIObject {
  const generator = new OpenApiGeneratorV31(registry.definitions);

  return generator.generateDocument({
    openapi: '3.1.0',
    info: {
      title: 'Hisab API',
      version: '1.0.0-alpha.1',
      description:
        'واجهة حساب الموثقة للمؤسسات والفواتير والمزامنة المحلية أولاً.',
      license: {
        name: 'MIT',
        url: 'https://github.com/usingn50/hisab-app/blob/main/LICENSE',
      },
    },
    security: [{ bearerAuth: [] }],
    servers: [{ url: '/v1', description: 'واجهة الإصدار الأول' }],
  });
}
