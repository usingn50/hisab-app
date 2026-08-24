import type { FastifyInstance } from 'fastify';

import {
  createProductSchema,
  stockAdjustmentSchema,
} from '../../contracts/catalog.js';
import { organizationIdSchema } from '../../contracts/organizations.js';
import { requireAccessToken } from '../auth/access.js';
import type { CatalogService } from './catalog-service.js';

export async function registerCatalogRoutes(
  app: FastifyInstance,
  catalogService: CatalogService,
): Promise<void> {
  app.get('/organizations/:organizationId/products', async (request) => {
    const access = await requireAccessToken(request);
    const organizationId = organizationIdSchema.parse(
      (request.params as { organizationId?: unknown }).organizationId,
    );
    return catalogService.listProducts(access.sub, organizationId);
  });

  app.post('/organizations/:organizationId/products', async (request, reply) => {
    const access = await requireAccessToken(request);
    const organizationId = organizationIdSchema.parse(
      (request.params as { organizationId?: unknown }).organizationId,
    );
    const payload = createProductSchema.parse(request.body);
    const product = await catalogService.createProduct(access.sub, organizationId, payload);
    return reply.status(201).send(product);
  });

  app.post(
    '/organizations/:organizationId/products/:productId/stock-adjustments',
    async (request, reply) => {
      const access = await requireAccessToken(request);
      const params = request.params as {
        organizationId?: unknown;
        productId?: unknown;
      };
      const organizationId = organizationIdSchema.parse(params.organizationId);
      const productId = organizationIdSchema.parse(params.productId);
      const payload = stockAdjustmentSchema.parse(request.body);
      await catalogService.adjustStock(access.sub, organizationId, productId, payload);
      return reply.status(204).send();
    },
  );
}
