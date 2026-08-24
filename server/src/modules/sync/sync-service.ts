import { createHash } from 'node:crypto';

import type { TransactionSql } from 'postgres';

import {
  createCustomerMutationSchema,
  createProductMutationSchema,
} from '../../contracts/sync.js';
import { ApiError } from '../../core/api-error.js';
import type { DatabaseClient } from '../../db/client.js';
import type { OrganizationService } from '../organizations/organization-service.js';

type Mutation = {
  mutationId: string;
  clientCreatedAt: string;
  operation: 'customer.create' | 'product.create';
  entityId: string;
  payload: unknown;
};

type MutationResult = {
  mutationId: string;
  status: 'applied' | 'duplicate' | 'conflict' | 'rejected';
  entityType: string;
  entityId: string;
  version: string | null;
  error: { code: string; message: string } | null;
};

type ChangeRow = {
  sequence: string;
  entity_type: string;
  entity_id: string;
  operation: 'upsert' | 'tombstone';
  entity_version: string;
  payload: Record<string, unknown>;
  changed_at: Date;
};

export class SyncService {
  constructor(
    private readonly database: DatabaseClient,
    private readonly organizations: OrganizationService,
  ) {}

  async pushMutations(
    userId: string,
    organizationId: string,
    deviceId: string,
    mutations: Mutation[],
  ): Promise<{ results: MutationResult[] }> {
    await this.organizations.requireRole(userId, organizationId, [
      'owner',
      'manager',
      'cashier',
      'accountant',
      'viewer',
    ]);

    const results: MutationResult[] = [];
    for (const mutation of mutations) {
      try {
        results.push(
          await this.processMutation(userId, organizationId, deviceId, mutation),
        );
      } catch (error) {
        results.push(this.toRejectedResult(mutation, error));
      }
    }

    return { results };
  }

  async pullChanges(
    userId: string,
    organizationId: string,
    cursor: string,
    limit: number,
  ) {
    await this.organizations.requireRole(userId, organizationId, [
      'owner',
      'manager',
      'cashier',
      'accountant',
      'viewer',
    ]);

    const rows = await this.database<ChangeRow[]>`
      SELECT sequence::text, entity_type, entity_id, operation, entity_version::text, payload, changed_at
      FROM change_log
      WHERE organization_id = ${organizationId}::uuid
        AND sequence > ${cursor}::bigint
      ORDER BY sequence ASC
      LIMIT ${limit + 1}
    `;
    const page = rows.slice(0, limit);
    const last = page.at(-1);

    return {
      changes: page.map((change) => ({
        sequence: change.sequence,
        entityType: change.entity_type,
        entityId: change.entity_id,
        operation: change.operation,
        version: change.entity_version,
        payload: change.payload,
        changedAt: change.changed_at.toISOString(),
      })),
      nextCursor: last?.sequence ?? cursor,
      hasMore: rows.length > limit,
    };
  }

  async bootstrap(userId: string, organizationId: string, deviceId: string) {
    await this.organizations.requireRole(userId, organizationId, [
      'owner',
      'manager',
      'cashier',
      'accountant',
      'viewer',
    ]);

    const snapshot = await this.database.begin(async (transaction) => {
      const [watermark] = await transaction<{ sequence: string }[]>`
        SELECT COALESCE(MAX(sequence), 0)::text AS sequence
        FROM change_log
        WHERE organization_id = ${organizationId}::uuid
      `;
      const highWatermarkCursor = watermark?.sequence ?? '0';
      const [bootstrap] = await transaction<{ id: string }[]>`
        INSERT INTO sync_bootstraps (
          organization_id,
          user_id,
          device_id,
          high_watermark_sequence,
          expires_at
        )
        VALUES (
          ${organizationId}::uuid,
          ${userId}::uuid,
          ${deviceId}::uuid,
          ${highWatermarkCursor}::bigint,
          now() + interval '24 hours'
        )
        RETURNING id
      `;
      if (!bootstrap) {
        throw new ApiError(500, 'BOOTSTRAP_CREATION_FAILED', 'تعذر إنشاء لقطة المزامنة.');
      }

      const branches = await transaction<{ data: Record<string, unknown> }[]>`
        SELECT to_jsonb(branches) AS data
        FROM branches
        WHERE organization_id = ${organizationId}::uuid
      `;
      const products = await transaction<{ data: Record<string, unknown> }[]>`
        SELECT to_jsonb(products) AS data
        FROM products
        WHERE organization_id = ${organizationId}::uuid
          AND deleted_at IS NULL
      `;
      const customers = await transaction<{ data: Record<string, unknown> }[]>`
        SELECT to_jsonb(customers) AS data
        FROM customers
        WHERE organization_id = ${organizationId}::uuid
          AND deleted_at IS NULL
      `;

      return {
        snapshotId: bootstrap.id,
        highWatermarkCursor,
        branches: branches.map((row) => row.data),
        products: products.map((row) => row.data),
        customers: customers.map((row) => row.data),
      };
    });

    return snapshot;
  }

  private async processMutation(
    userId: string,
    organizationId: string,
    deviceId: string,
    mutation: Mutation,
  ): Promise<MutationResult> {
    const requestHash = this.hashMutation(mutation);

    return this.database.begin(async (transaction) => {
      const [existing] = await transaction<{
        request_hash: string;
        result_json: MutationResult | string;
      }[]>`
        SELECT request_hash, result_json
        FROM client_mutations
        WHERE organization_id = ${organizationId}::uuid
          AND device_id = ${deviceId}::uuid
          AND mutation_id = ${mutation.mutationId}::uuid
        LIMIT 1
        FOR UPDATE
      `;
      if (existing) {
        if (existing.request_hash !== requestHash) {
          throw new ApiError(409, 'MUTATION_REUSE_MISMATCH', 'أعيد استخدام معرف الأمر مع بيانات مختلفة.');
        }
        const stored =
          typeof existing.result_json === 'string'
            ? (JSON.parse(existing.result_json) as MutationResult)
            : existing.result_json;
        return { ...stored, status: 'duplicate' as const };
      }

      const result = await this.applyMutation(
        transaction,
        userId,
        organizationId,
        mutation,
      );

      await transaction`
        INSERT INTO client_mutations (
          organization_id,
          device_id,
          mutation_id,
          request_hash,
          operation,
          status,
          result_json
        )
        VALUES (
          ${organizationId}::uuid,
          ${deviceId}::uuid,
          ${mutation.mutationId}::uuid,
          ${requestHash},
          ${mutation.operation},
          'applied',
          ${JSON.stringify(result)}::jsonb
        )
      `;

      return result;
    });
  }

  private async applyMutation(
    transaction: TransactionSql<{}>,
    userId: string,
    organizationId: string,
    mutation: Mutation,
  ): Promise<MutationResult> {
    if (mutation.operation === 'customer.create') {
      await this.organizations.requireRole(userId, organizationId, [
        'owner',
        'manager',
        'cashier',
      ]);
      const command = createCustomerMutationSchema.parse({
        operation: mutation.operation,
        entityId: mutation.entityId,
        payload: mutation.payload,
      });
      const [customer] = await transaction<{ version: string }[]>`
        INSERT INTO customers (
          id,
          organization_id,
          name,
          phone_e164,
          credit_limit_minor
        )
        VALUES (
          ${command.entityId}::uuid,
          ${organizationId}::uuid,
          ${command.payload.name},
          ${command.payload.phone ?? null},
          ${command.payload.creditLimitMinor ?? null}
        )
        RETURNING version::text
      `;
      if (!customer) {
        throw new ApiError(500, 'SYNC_CUSTOMER_CREATE_FAILED', 'تعذر إنشاء العميل أثناء المزامنة.');
      }
      await transaction`
        INSERT INTO audit_events (organization_id, actor_user_id, action, entity_type, entity_id, after_data)
        VALUES (
          ${organizationId}::uuid,
          ${userId}::uuid,
          'sync.customer.created',
          'customer',
          ${command.entityId}::uuid,
          ${JSON.stringify(command.payload)}::jsonb
        )
      `;
      return {
        mutationId: mutation.mutationId,
        status: 'applied',
        entityType: 'customer',
        entityId: command.entityId,
        version: customer.version,
        error: null,
      };
    }

    await this.organizations.requireRole(userId, organizationId, ['owner', 'manager']);
    const command = createProductMutationSchema.parse({
      operation: mutation.operation,
      entityId: mutation.entityId,
      payload: mutation.payload,
    });
    const [product] = await transaction<{ version: string }[]>`
      INSERT INTO products (
        id,
        organization_id,
        name,
        sku,
        barcode,
        sell_price_minor,
        currency_code,
        min_stock_quantity
      )
      VALUES (
        ${command.entityId}::uuid,
        ${organizationId}::uuid,
        ${command.payload.name},
        ${command.payload.sku ?? null},
        ${command.payload.barcode ?? null},
        ${command.payload.sellPriceMinor},
        ${command.payload.currencyCode},
        ${command.payload.minStockQuantity}
      )
      RETURNING version::text
    `;
    if (!product) {
      throw new ApiError(500, 'SYNC_PRODUCT_CREATE_FAILED', 'تعذر إنشاء المنتج أثناء المزامنة.');
    }
    await transaction`
      INSERT INTO audit_events (organization_id, actor_user_id, action, entity_type, entity_id, after_data)
      VALUES (
        ${organizationId}::uuid,
        ${userId}::uuid,
        'sync.product.created',
        'product',
        ${command.entityId}::uuid,
        ${JSON.stringify(command.payload)}::jsonb
      )
    `;
    return {
      mutationId: mutation.mutationId,
      status: 'applied',
      entityType: 'product',
      entityId: command.entityId,
      version: product.version,
      error: null,
    };
  }

  private toRejectedResult(mutation: Mutation, error: unknown): MutationResult {
    if (error instanceof ApiError) {
      return {
        mutationId: mutation.mutationId,
        status: error.statusCode === 409 ? 'conflict' : 'rejected',
        entityType: mutation.operation.split('.')[0] ?? 'unknown',
        entityId: mutation.entityId,
        version: null,
        error: { code: error.code, message: error.message },
      };
    }
    return {
      mutationId: mutation.mutationId,
      status: 'rejected',
      entityType: mutation.operation.split('.')[0] ?? 'unknown',
      entityId: mutation.entityId,
      version: null,
      error: { code: 'SYNC_OPERATION_FAILED', message: 'تعذر تنفيذ أمر المزامنة.' },
    };
  }

  private hashMutation(mutation: Mutation): string {
    return createHash('sha256').update(JSON.stringify(mutation)).digest('hex');
  }
}
