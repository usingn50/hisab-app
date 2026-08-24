import type { FastifyInstance } from 'fastify';

import {
  addOrganizationMemberSchema,
  createOrganizationSchema,
  organizationIdSchema,
} from '../../contracts/organizations.js';
import { requireAccessToken } from '../auth/access.js';
import type { OrganizationService } from './organization-service.js';

export async function registerOrganizationRoutes(
  app: FastifyInstance,
  organizationService: OrganizationService,
): Promise<void> {
  app.get('/organizations', async (request) => {
    const access = await requireAccessToken(request);
    return organizationService.listForUser(access.sub);
  });

  app.post('/organizations', async (request, reply) => {
    const access = await requireAccessToken(request);
    const payload = createOrganizationSchema.parse(request.body);
    const organization = await organizationService.create(access.sub, payload);
    return reply.status(201).send(organization);
  });

  app.post('/organizations/:organizationId/members', async (request, reply) => {
    const access = await requireAccessToken(request);
    const organizationId = organizationIdSchema.parse(
      (request.params as { organizationId?: unknown }).organizationId,
    );
    const payload = addOrganizationMemberSchema.parse(request.body);
    const member = await organizationService.addMember(access.sub, organizationId, payload);
    return reply.status(201).send(member);
  });

  app.get('/organizations/:organizationId/branches', async (request) => {
    const access = await requireAccessToken(request);
    const params = organizationIdSchema.parse(
      (request.params as { organizationId?: unknown }).organizationId,
    );
    return organizationService.listBranches(access.sub, params);
  });
}
