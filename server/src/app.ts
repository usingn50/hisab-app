import { randomUUID } from 'node:crypto';

import cors from '@fastify/cors';
import jwt from '@fastify/jwt';
import Fastify, { type FastifyInstance } from 'fastify';
import { ZodError } from 'zod';

import type { AppConfig } from './config.js';
import { ApiError } from './core/api-error.js';
import { createDatabaseClient, type DatabaseClient } from './db/client.js';
import { AuthService } from './modules/auth/auth-service.js';
import { registerAuthRoutes } from './modules/auth/auth-routes.js';
import { registerCatalogRoutes } from './modules/catalog/catalog-routes.js';
import { CatalogService } from './modules/catalog/catalog-service.js';
import { registerCustomerRoutes } from './modules/customers/customer-routes.js';
import { CustomerService } from './modules/customers/customer-service.js';
import { registerOrganizationRoutes } from './modules/organizations/organization-routes.js';
import { OrganizationService } from './modules/organizations/organization-service.js';
import { registerSalesRoutes } from './modules/sales/sales-routes.js';
import { SalesService } from './modules/sales/sales-service.js';
import { registerSyncRoutes } from './modules/sync/sync-routes.js';
import { SyncService } from './modules/sync/sync-service.js';
import { buildOpenApiDocument } from './openapi/document.js';

export function buildApp(
  config: AppConfig,
  database: DatabaseClient = createDatabaseClient(config),
): FastifyInstance {
  const app = Fastify({
    logger: config.NODE_ENV !== 'test',
    genReqId: () => randomUUID(),
  });

  app.register(cors, {
    origin: config.CORS_ORIGIN,
    credentials: true,
  });
  app.register(jwt, { secret: config.JWT_ACCESS_SECRET });
  app.addHook('onClose', async () => database.end({ timeout: 5 }));

  const authService = new AuthService(database, app, config);
  const organizationService = new OrganizationService(database);
  const catalogService = new CatalogService(database, organizationService);
  const customerService = new CustomerService(database, organizationService);
  const salesService = new SalesService(database, organizationService);
  const syncService = new SyncService(database, organizationService);
  app.register((instance) => registerAuthRoutes(instance, authService));
  app.register((instance) => registerOrganizationRoutes(instance, organizationService));
  app.register((instance) => registerCatalogRoutes(instance, catalogService));
  app.register((instance) => registerCustomerRoutes(instance, customerService));
  app.register((instance) => registerSalesRoutes(instance, salesService));
  app.register((instance) => registerSyncRoutes(instance, syncService));

  app.get('/health', async () => ({
    status: 'ok' as const,
    service: 'hisab-api' as const,
    timestamp: new Date().toISOString(),
  }));

  app.get('/openapi.json', async () => buildOpenApiDocument());

  app.setErrorHandler((error, request, reply) => {
    const requestId = request.id;

    if (error instanceof ApiError) {
      return reply.status(error.statusCode).send({
        error: {
          code: error.code,
          message: error.message,
          requestId,
          details: error.details,
        },
      });
    }

    if (error instanceof ZodError) {
      return reply.status(422).send({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'تعذر التحقق من البيانات المدخلة.',
          requestId,
          details: error.issues.map((issue) => ({
            field: issue.path.join('.') || 'request',
            reason: issue.message,
          })),
        },
      });
    }

    request.log.error(error);
    return reply.status(500).send({
      error: {
        code: 'INTERNAL_ERROR',
        message: 'حدث خطأ غير متوقع. حاول مرة أخرى.',
        requestId,
        details: [],
      },
    });
  });

  return app;
}
