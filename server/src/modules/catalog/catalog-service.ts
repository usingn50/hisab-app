import { ApiError } from '../../core/api-error.js';
import type { DatabaseClient } from '../../db/client.js';
import type { OrganizationService } from '../organizations/organization-service.js';

type ProductRow = {
  id: string;
  name: string;
  sku: string | null;
  barcode: string | null;
  sell_price_minor: number;
  currency_code: string;
  min_stock_quantity: number;
  is_active: boolean;
  version: string;
};

type CreateProductInput = {
  name: string;
  sku?: string | undefined;
  barcode?: string | undefined;
  sellPriceMinor: number;
  currencyCode: 'YER' | 'USD' | 'SAR';
  minStockQuantity: number;
};

type StockAdjustmentInput = {
  branchId: string;
  quantityDelta: number;
  reason: 'adjustment';
};

export class CatalogService {
  constructor(
    private readonly database: DatabaseClient,
    private readonly organizations: OrganizationService,
  ) {}

  async listProducts(userId: string, organizationId: string) {
    await this.organizations.requireRole(userId, organizationId, [
      'owner',
      'manager',
      'cashier',
      'accountant',
      'viewer',
    ]);

    const products = await this.database<ProductRow[]>`
      SELECT
        id,
        name,
        sku,
        barcode,
        sell_price_minor,
        currency_code,
        min_stock_quantity,
        is_active,
        version::text
      FROM products
      WHERE organization_id = ${organizationId}::uuid
        AND deleted_at IS NULL
      ORDER BY name ASC
    `;

    return products.map((product) => this.toProduct(product));
  }

  async createProduct(
    userId: string,
    organizationId: string,
    input: CreateProductInput,
  ) {
    await this.organizations.requireRole(userId, organizationId, ['owner', 'manager']);

    try {
      const [product] = await this.database<ProductRow[]>`
        INSERT INTO products (
          organization_id,
          name,
          sku,
          barcode,
          sell_price_minor,
          currency_code,
          min_stock_quantity
        )
        VALUES (
          ${organizationId}::uuid,
          ${input.name},
          ${input.sku ?? null},
          ${input.barcode ?? null},
          ${input.sellPriceMinor},
          ${input.currencyCode},
          ${input.minStockQuantity}
        )
        RETURNING
          id,
          name,
          sku,
          barcode,
          sell_price_minor,
          currency_code,
          min_stock_quantity,
          is_active,
          version::text
      `;

      if (!product) {
        throw new ApiError(500, 'PRODUCT_CREATION_FAILED', 'تعذر إنشاء المنتج.');
      }

      await this.database`
        INSERT INTO audit_events (organization_id, actor_user_id, action, entity_type, entity_id, after_data)
        VALUES (
          ${organizationId}::uuid,
          ${userId}::uuid,
          'product.created',
          'product',
          ${product.id}::uuid,
          ${JSON.stringify({ name: product.name, currencyCode: product.currency_code })}::jsonb
        )
      `;

      return this.toProduct(product);
    } catch (error) {
      if (this.isUniqueViolation(error)) {
        throw new ApiError(409, 'PRODUCT_IDENTIFIER_EXISTS', 'الباركود أو رمز المنتج مستخدم بالفعل.');
      }
      throw error;
    }
  }

  async adjustStock(
    userId: string,
    organizationId: string,
    productId: string,
    input: StockAdjustmentInput,
  ): Promise<void> {
    await this.organizations.requireRole(userId, organizationId, ['owner', 'manager']);

    await this.database.begin(async (transaction) => {
      const [product] = await transaction<{ id: string }[]>`
        SELECT id
        FROM products
        WHERE id = ${productId}::uuid
          AND organization_id = ${organizationId}::uuid
          AND deleted_at IS NULL
        LIMIT 1
        FOR UPDATE
      `;
      if (!product) {
        throw new ApiError(404, 'PRODUCT_NOT_FOUND', 'المنتج غير موجود في هذه المؤسسة.');
      }

      const [branch] = await transaction<{ id: string }[]>`
        SELECT id
        FROM branches
        WHERE id = ${input.branchId}::uuid
          AND organization_id = ${organizationId}::uuid
          AND is_active = true
        LIMIT 1
      `;
      if (!branch) {
        throw new ApiError(422, 'BRANCH_INVALID', 'الفرع المحدد غير صالح.');
      }

      const [balance] = await transaction<{ quantity: number }[]>`
        SELECT quantity
        FROM stock_balances
        WHERE branch_id = ${input.branchId}::uuid
          AND product_id = ${productId}::uuid
        LIMIT 1
        FOR UPDATE
      `;
      const nextQuantity = (balance?.quantity ?? 0) + input.quantityDelta;
      if (nextQuantity < 0) {
        throw new ApiError(409, 'STOCK_NEGATIVE', 'التسوية ستنتج كمية مخزون سالبة.');
      }

      if (balance) {
        await transaction`
          UPDATE stock_balances
          SET quantity = ${nextQuantity}, version = version + 1, updated_at = now()
          WHERE branch_id = ${input.branchId}::uuid
            AND product_id = ${productId}::uuid
        `;
      } else {
        await transaction`
          INSERT INTO stock_balances (organization_id, branch_id, product_id, quantity)
          VALUES (${organizationId}::uuid, ${input.branchId}::uuid, ${productId}::uuid, ${nextQuantity})
        `;
      }

      await transaction`
        INSERT INTO stock_movements (
          organization_id,
          branch_id,
          product_id,
          quantity_delta,
          reason,
          occurred_at,
          created_by
        )
        VALUES (
          ${organizationId}::uuid,
          ${input.branchId}::uuid,
          ${productId}::uuid,
          ${input.quantityDelta},
          'adjustment',
          now(),
          ${userId}::uuid
        )
      `;

      await transaction`
        INSERT INTO audit_events (organization_id, actor_user_id, action, entity_type, entity_id, after_data)
        VALUES (
          ${organizationId}::uuid,
          ${userId}::uuid,
          'stock.adjusted',
          'product',
          ${productId}::uuid,
          ${JSON.stringify({ branchId: input.branchId, quantityDelta: input.quantityDelta })}::jsonb
        )
      `;
    });
  }

  private toProduct(product: ProductRow) {
    return {
      id: product.id,
      name: product.name,
      sku: product.sku,
      barcode: product.barcode,
      sellPriceMinor: product.sell_price_minor,
      currencyCode: product.currency_code,
      minStockQuantity: product.min_stock_quantity,
      isActive: product.is_active,
      version: product.version,
    };
  }

  private isUniqueViolation(error: unknown): boolean {
    return typeof error === 'object' && error !== null && 'code' in error && error.code === '23505';
  }
}
