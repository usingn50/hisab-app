import type { FastifyInstance } from 'fastify';

import {
  createCustomerSchema,
  recordCustomerPaymentSchema,
} from '../../contracts/customers.js';
import { organizationIdSchema } from '../../contracts/organizations.js';
import { requireAccessToken } from '../auth/access.js';
import type { CustomerService } from './customer-service.js';

export async function registerCustomerRoutes(
  app: FastifyInstance,
  customerService: CustomerService,
): Promise<void> {
  app.get('/organizations/:organizationId/customers', async (request) => {
    const access = await requireAccessToken(request);
    const organizationId = organizationIdSchema.parse(
      (request.params as { organizationId?: unknown }).organizationId,
    );
    return customerService.list(access.sub, organizationId);
  });

  app.post('/organizations/:organizationId/customers/:customerId/payments', async (request, reply) => {
    const access = await requireAccessToken(request);
    const params = request.params as { organizationId?: unknown; customerId?: unknown };
    const organizationId = organizationIdSchema.parse(params.organizationId);
    const customerId = organizationIdSchema.parse(params.customerId);
    const payload = recordCustomerPaymentSchema.parse(request.body);
    const payment = await customerService.recordPayment(
      access.sub,
      organizationId,
      customerId,
      payload,
    );
    return reply.status(201).send(payment);
  });

  app.post('/organizations/:organizationId/customers', async (request, reply) => {
    const access = await requireAccessToken(request);
    const organizationId = organizationIdSchema.parse(
      (request.params as { organizationId?: unknown }).organizationId,
    );
    const payload = createCustomerSchema.parse(request.body);
    const customer = await customerService.create(access.sub, organizationId, payload);
    return reply.status(201).send(customer);
  });
}
