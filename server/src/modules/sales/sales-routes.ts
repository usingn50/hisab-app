import type { FastifyInstance } from 'fastify';

import { issueInvoiceSchema } from '../../contracts/sales.js';
import { organizationIdSchema } from '../../contracts/organizations.js';
import { requireAccessToken } from '../auth/access.js';
import type { SalesService } from './sales-service.js';

export async function registerSalesRoutes(
  app: FastifyInstance,
  salesService: SalesService,
): Promise<void> {
  app.post('/organizations/:organizationId/invoices/issue', async (request, reply) => {
    const access = await requireAccessToken(request);
    const organizationId = organizationIdSchema.parse(
      (request.params as { organizationId?: unknown }).organizationId,
    );
    const payload = issueInvoiceSchema.parse(request.body);
    const invoice = await salesService.issueInvoice(access.sub, organizationId, payload);
    return reply.status(201).send(invoice);
  });
}
