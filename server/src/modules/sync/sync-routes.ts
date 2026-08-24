import type { FastifyInstance } from 'fastify';

import {
  pullChangesQuerySchema,
  pushMutationsSchema,
} from '../../contracts/sync.js';
import { organizationIdSchema } from '../../contracts/organizations.js';
import { requireAccessToken } from '../auth/access.js';
import type { SyncService } from './sync-service.js';

export async function registerSyncRoutes(
  app: FastifyInstance,
  syncService: SyncService,
): Promise<void> {
  app.post('/organizations/:organizationId/sync/mutations', async (request) => {
    const access = await requireAccessToken(request);
    const organizationId = organizationIdSchema.parse(
      (request.params as { organizationId?: unknown }).organizationId,
    );
    const payload = pushMutationsSchema.parse(request.body);
    return syncService.pushMutations(
      access.sub,
      organizationId,
      payload.deviceId,
      payload.mutations,
    );
  });

  app.get('/organizations/:organizationId/sync/changes', async (request) => {
    const access = await requireAccessToken(request);
    const organizationId = organizationIdSchema.parse(
      (request.params as { organizationId?: unknown }).organizationId,
    );
    const query = pullChangesQuerySchema.parse(request.query);
    return syncService.pullChanges(access.sub, organizationId, query.cursor, query.limit);
  });

  app.post('/organizations/:organizationId/sync/bootstrap', async (request) => {
    const access = await requireAccessToken(request);
    const organizationId = organizationIdSchema.parse(
      (request.params as { organizationId?: unknown }).organizationId,
    );
    const body = request.body as { deviceId?: unknown };
    const deviceId = organizationIdSchema.parse(body.deviceId);
    return syncService.bootstrap(access.sub, organizationId, deviceId);
  });
}
