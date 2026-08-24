import { ApiError } from '../../core/api-error.js';
import type { DatabaseClient } from '../../db/client.js';
import type { OrganizationService } from '../organizations/organization-service.js';

type IssueInvoiceInput = {
  branchId: string;
  customerId?: string | undefined;
  currencyCode: 'YER' | 'USD' | 'SAR';
  exchangeRate: string;
  lines: Array<{
    productId: string;
    quantity: number;
    unitPriceMinor: number;
  }>;
  payment: {
    method: 'cash' | 'credit' | 'bank_transfer' | 'wallet';
    amountMinor: number;
  };
};

type ProductForSale = {
  id: string;
  name: string;
  currency_code: string;
};

type CurrencyRow = {
  code: string;
  minor_unit: number;
};

type InvoiceRow = {
  id: string;
  status: 'issued';
  branch_id: string;
  customer_id: string | null;
  currency_code: string;
  exchange_rate: string;
  total_minor: number;
  base_total_minor: number;
  issued_at: Date;
};

export class SalesService {
  constructor(
    private readonly database: DatabaseClient,
    private readonly organizations: OrganizationService,
  ) {}

  async issueInvoice(
    userId: string,
    organizationId: string,
    input: IssueInvoiceInput,
  ) {
    await this.organizations.requireRole(userId, organizationId, [
      'owner',
      'manager',
      'cashier',
    ]);

    this.assertNoDuplicateProducts(input.lines);

    return this.database.begin(async (transaction) => {
      const [organization] = await transaction<{
        base_currency_code: string;
      }[]>`
        SELECT base_currency_code
        FROM organizations
        WHERE id = ${organizationId}::uuid
        LIMIT 1
      `;
      if (!organization) {
        throw new ApiError(404, 'ORGANIZATION_NOT_FOUND', 'المؤسسة غير موجودة.');
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

      let customerCreditLimit: number | null = null;
      if (input.customerId) {
        const [customer] = await transaction<{ id: string; credit_limit_minor: number | null }[]>`
          SELECT id, credit_limit_minor
          FROM customers
          WHERE id = ${input.customerId}::uuid
            AND organization_id = ${organizationId}::uuid
            AND deleted_at IS NULL
          LIMIT 1
        `;
        if (!customer) {
          throw new ApiError(422, 'CUSTOMER_INVALID', 'العميل المحدد غير صالح.');
        }
        customerCreditLimit = customer.credit_limit_minor;
      }

      const currencyRows = await transaction<CurrencyRow[]>`
        SELECT code, minor_unit
        FROM currencies
        WHERE code IN (${input.currencyCode}, ${organization.base_currency_code})
      `;
      const currencies = new Map(currencyRows.map((currency) => [currency.code, currency]));
      const sourceCurrency = currencies.get(input.currencyCode);
      const baseCurrency = currencies.get(organization.base_currency_code);
      if (!sourceCurrency || !baseCurrency) {
        throw new ApiError(422, 'CURRENCY_INVALID', 'العملة المحددة غير مدعومة.');
      }

      const products = new Map<string, ProductForSale>();
      for (const productId of [...input.lines.map((line) => line.productId)].sort()) {
        const [product] = await transaction<ProductForSale[]>`
          SELECT id, name, currency_code
          FROM products
          WHERE id = ${productId}::uuid
            AND organization_id = ${organizationId}::uuid
            AND is_active = true
            AND deleted_at IS NULL
          LIMIT 1
          FOR UPDATE
        `;
        if (!product) {
          throw new ApiError(422, 'PRODUCT_INVALID', 'أحد منتجات الفاتورة غير صالح.');
        }
        if (product.currency_code !== input.currencyCode) {
          throw new ApiError(422, 'PRODUCT_CURRENCY_MISMATCH', 'عملة المنتج لا تطابق عملة الفاتورة.');
        }
        products.set(product.id, product);
      }

      let totalMinor = 0;
      let baseTotalMinor = 0;
      const calculatedLines = input.lines.map((line) => {
        const lineTotalMinor = this.safeInteger(line.unitPriceMinor * line.quantity);
        const baseLineTotalMinor = this.toBaseMinor(
          lineTotalMinor,
          input.exchangeRate,
          sourceCurrency.minor_unit,
          baseCurrency.minor_unit,
        );
        totalMinor = this.safeInteger(totalMinor + lineTotalMinor);
        baseTotalMinor = this.safeInteger(baseTotalMinor + baseLineTotalMinor);
        return { ...line, lineTotalMinor, baseLineTotalMinor };
      });

      if (input.payment.amountMinor > totalMinor) {
        throw new ApiError(422, 'PAYMENT_EXCEEDS_TOTAL', 'المبلغ المستلم يتجاوز إجمالي الفاتورة.');
      }
      if (input.payment.amountMinor < totalMinor && !input.customerId) {
        throw new ApiError(422, 'CUSTOMER_REQUIRED_FOR_CREDIT', 'يجب اختيار عميل عند وجود مبلغ آجل.');
      }
      if (input.payment.method === 'credit' && input.payment.amountMinor !== 0) {
        throw new ApiError(422, 'CREDIT_PAYMENT_INVALID', 'طريقة البيع الآجل لا تقبل مبلغاً مستلماً.');
      }

      for (const line of [...calculatedLines].sort((left, right) => left.productId.localeCompare(right.productId))) {
        const [balance] = await transaction<{ quantity: number }[]>`
          SELECT quantity
          FROM stock_balances
          WHERE branch_id = ${input.branchId}::uuid
            AND product_id = ${line.productId}::uuid
          LIMIT 1
          FOR UPDATE
        `;
        if (!balance || balance.quantity < line.quantity) {
          throw new ApiError(409, 'INSUFFICIENT_STOCK', 'المخزون المتاح لا يكفي لإتمام الفاتورة.', [
            { field: 'lines', reason: `insufficient_stock:${line.productId}` },
          ]);
        }
      }

      const [invoice] = await transaction<InvoiceRow[]>`
        INSERT INTO invoices (
          id,
          organization_id,
          branch_id,
          customer_id,
          status,
          currency_code,
          exchange_rate,
          subtotal_minor,
          total_minor,
          base_total_minor,
          issued_at,
          created_by
        )
        VALUES (
          gen_random_uuid(),
          ${organizationId}::uuid,
          ${input.branchId}::uuid,
          ${input.customerId ?? null}::uuid,
          'issued',
          ${input.currencyCode},
          ${input.exchangeRate}::numeric,
          ${totalMinor},
          ${totalMinor},
          ${baseTotalMinor},
          now(),
          ${userId}::uuid
        )
        RETURNING id, status, branch_id, customer_id, currency_code, exchange_rate::text, total_minor, base_total_minor, issued_at
      `;
      if (!invoice) {
        throw new ApiError(500, 'INVOICE_CREATION_FAILED', 'تعذر إصدار الفاتورة.');
      }

      for (const line of calculatedLines) {
        const product = products.get(line.productId);
        if (!product) {
          throw new ApiError(500, 'PRODUCT_LOOKUP_FAILED', 'تعذر تجهيز بيانات المنتج.');
        }
        const [invoiceLine] = await transaction<{ id: string }[]>`
          INSERT INTO invoice_lines (
            invoice_id,
            product_id,
            description_snapshot,
            quantity,
            unit_price_minor,
            line_total_minor,
            base_line_total_minor
          )
          VALUES (
            ${invoice.id}::uuid,
            ${line.productId}::uuid,
            ${product.name},
            ${line.quantity},
            ${line.unitPriceMinor},
            ${line.lineTotalMinor},
            ${line.baseLineTotalMinor}
          )
          RETURNING id
        `;
        if (!invoiceLine) {
          throw new ApiError(500, 'INVOICE_LINE_CREATION_FAILED', 'تعذر حفظ أحد بنود الفاتورة.');
        }

        await transaction`
          UPDATE stock_balances
          SET quantity = quantity - ${line.quantity}, version = version + 1, updated_at = now()
          WHERE branch_id = ${input.branchId}::uuid
            AND product_id = ${line.productId}::uuid
        `;

        await transaction`
          INSERT INTO stock_movements (
            organization_id,
            branch_id,
            product_id,
            invoice_line_id,
            quantity_delta,
            reason,
            occurred_at,
            created_by
          )
          VALUES (
            ${organizationId}::uuid,
            ${input.branchId}::uuid,
            ${line.productId}::uuid,
            ${invoiceLine.id}::uuid,
            ${-line.quantity},
            'sale',
            now(),
            ${userId}::uuid
          )
        `;
      }

      const paymentBaseMinor = this.toBaseMinor(
        input.payment.amountMinor,
        input.exchangeRate,
        sourceCurrency.minor_unit,
        baseCurrency.minor_unit,
      );
      if (input.payment.amountMinor > 0) {
        const [payment] = await transaction<{ id: string }[]>`
          INSERT INTO payments (
            organization_id,
            invoice_id,
            method,
            amount_minor,
            currency_code,
            exchange_rate,
            base_amount_minor,
            received_at,
            received_by
          )
          VALUES (
            ${organizationId}::uuid,
            ${invoice.id}::uuid,
            ${input.payment.method},
            ${input.payment.amountMinor},
            ${input.currencyCode},
            ${input.exchangeRate}::numeric,
            ${paymentBaseMinor},
            now(),
            ${userId}::uuid
          )
          RETURNING id
        `;
        if (!payment) {
          throw new ApiError(500, 'PAYMENT_CREATION_FAILED', 'تعذر تسجيل الدفعة.');
        }
      }

      const outstandingBaseMinor = this.safeInteger(baseTotalMinor - paymentBaseMinor);
      if (outstandingBaseMinor > 0 && input.customerId && customerCreditLimit !== null) {
        const [ledger] = await transaction<{ balance: string }[]>`
          SELECT COALESCE(
            SUM(
              CASE entry_type
                WHEN 'debit' THEN amount_base_minor
                WHEN 'credit' THEN -amount_base_minor
                WHEN 'refund' THEN -amount_base_minor
                ELSE amount_base_minor
              END
            ),
            0
          )::text AS balance
          FROM customer_ledger_entries
          WHERE customer_id = ${input.customerId}::uuid
        `;
        if (BigInt(ledger?.balance ?? '0') + BigInt(outstandingBaseMinor) > BigInt(customerCreditLimit)) {
          throw new ApiError(409, 'CREDIT_LIMIT_EXCEEDED', 'المبلغ الآجل يتجاوز حد ائتمان العميل.');
        }
      }
      if (outstandingBaseMinor > 0 && input.customerId) {
        await transaction`
          INSERT INTO customer_ledger_entries (
            organization_id,
            customer_id,
            invoice_id,
            entry_type,
            amount_base_minor,
            occurred_at,
            created_by
          )
          VALUES (
            ${organizationId}::uuid,
            ${input.customerId}::uuid,
            ${invoice.id}::uuid,
            'debit',
            ${outstandingBaseMinor},
            now(),
            ${userId}::uuid
          )
        `;
      }

      if (input.currencyCode !== organization.base_currency_code) {
        await transaction`
          INSERT INTO exchange_rates (
            organization_id,
            from_currency_code,
            to_currency_code,
            rate,
            effective_at,
            created_by
          )
          VALUES (
            ${organizationId}::uuid,
            ${input.currencyCode},
            ${organization.base_currency_code},
            ${input.exchangeRate}::numeric,
            now(),
            ${userId}::uuid
          )
        `;
      }

      await transaction`
        INSERT INTO audit_events (organization_id, actor_user_id, action, entity_type, entity_id, after_data)
        VALUES (
          ${organizationId}::uuid,
          ${userId}::uuid,
          'invoice.issued',
          'invoice',
          ${invoice.id}::uuid,
          ${JSON.stringify({ totalMinor, baseTotalMinor, outstandingBaseMinor })}::jsonb
        )
      `;

      return {
        id: invoice.id,
        status: invoice.status,
        branchId: invoice.branch_id,
        customerId: invoice.customer_id,
        currencyCode: invoice.currency_code,
        exchangeRate: invoice.exchange_rate,
        totalMinor: invoice.total_minor,
        baseTotalMinor: invoice.base_total_minor,
        outstandingBaseMinor,
        issuedAt: invoice.issued_at.toISOString(),
      };
    });
  }

  private assertNoDuplicateProducts(lines: IssueInvoiceInput['lines']): void {
    const ids = new Set(lines.map((line) => line.productId));
    if (ids.size !== lines.length) {
      throw new ApiError(422, 'DUPLICATE_PRODUCT_LINE', 'لا يمكن تكرار المنتج في بنود الفاتورة.');
    }
  }

  private toBaseMinor(
    amountMinor: number,
    rate: string,
    sourceMinorUnit: number,
    baseMinorUnit: number,
  ): number {
    const [whole, fraction = ''] = rate.split('.');
    const normalized = `${whole}${fraction.padEnd(12, '0')}`;
    const rateScaled = BigInt(normalized);
    const numerator = BigInt(amountMinor) * rateScaled * BigInt(10 ** baseMinorUnit);
    const denominator = BigInt(10 ** sourceMinorUnit) * 1_000_000_000_000n;
    return this.toSafeNumber((numerator + denominator / 2n) / denominator);
  }

  private safeInteger(value: number): number {
    if (!Number.isSafeInteger(value) || value < 0) {
      throw new ApiError(422, 'AMOUNT_OUT_OF_RANGE', 'قيمة المبلغ خارج النطاق المدعوم.');
    }
    return value;
  }

  private toSafeNumber(value: bigint): number {
    if (value > BigInt(Number.MAX_SAFE_INTEGER)) {
      throw new ApiError(422, 'AMOUNT_OUT_OF_RANGE', 'قيمة المبلغ خارج النطاق المدعوم.');
    }
    return Number(value);
  }
}
