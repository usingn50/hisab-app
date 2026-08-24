import { ApiError } from '../../core/api-error.js';
import type { DatabaseClient } from '../../db/client.js';
import type { OrganizationService } from '../organizations/organization-service.js';

type CustomerRow = {
  id: string;
  name: string;
  phone_e164: string | null;
  credit_limit_minor: number | null;
  version: string;
};

type CreateCustomerInput = {
  name: string;
  phone?: string | undefined;
  creditLimitMinor?: number | undefined;
};

type RecordCustomerPaymentInput = {
  method: 'cash' | 'bank_transfer' | 'wallet';
  amountMinor: number;
  currencyCode: 'YER' | 'USD' | 'SAR';
  exchangeRate: string;
};

export class CustomerService {
  constructor(
    private readonly database: DatabaseClient,
    private readonly organizations: OrganizationService,
  ) {}

  async list(userId: string, organizationId: string) {
    await this.organizations.requireRole(userId, organizationId, [
      'owner',
      'manager',
      'cashier',
      'accountant',
      'viewer',
    ]);

    const customers = await this.database<CustomerRow[]>`
      SELECT id, name, phone_e164, credit_limit_minor, version::text
      FROM customers
      WHERE organization_id = ${organizationId}::uuid
        AND deleted_at IS NULL
      ORDER BY name ASC
    `;

    return customers.map((customer) => this.toCustomer(customer));
  }

  async create(userId: string, organizationId: string, input: CreateCustomerInput) {
    await this.organizations.requireRole(userId, organizationId, [
      'owner',
      'manager',
      'cashier',
    ]);

    const [customer] = await this.database<CustomerRow[]>`
      INSERT INTO customers (organization_id, name, phone_e164, credit_limit_minor)
      VALUES (
        ${organizationId}::uuid,
        ${input.name},
        ${input.phone ?? null},
        ${input.creditLimitMinor ?? null}
      )
      RETURNING id, name, phone_e164, credit_limit_minor, version::text
    `;
    if (!customer) {
      throw new ApiError(500, 'CUSTOMER_CREATION_FAILED', 'تعذر إنشاء العميل.');
    }

    await this.database`
      INSERT INTO audit_events (organization_id, actor_user_id, action, entity_type, entity_id, after_data)
      VALUES (
        ${organizationId}::uuid,
        ${userId}::uuid,
        'customer.created',
        'customer',
        ${customer.id}::uuid,
        ${JSON.stringify({ name: customer.name })}::jsonb
      )
    `;

    return this.toCustomer(customer);
  }

  async recordPayment(
    userId: string,
    organizationId: string,
    customerId: string,
    input: RecordCustomerPaymentInput,
  ) {
    await this.organizations.requireRole(userId, organizationId, [
      'owner',
      'manager',
      'cashier',
    ]);

    return this.database.begin(async (transaction) => {
      const [customer] = await transaction<{ id: string }[]>`
        SELECT id
        FROM customers
        WHERE id = ${customerId}::uuid
          AND organization_id = ${organizationId}::uuid
          AND deleted_at IS NULL
        LIMIT 1
        FOR UPDATE
      `;
      if (!customer) {
        throw new ApiError(422, 'CUSTOMER_INVALID', 'العميل المحدد غير صالح.');
      }

      const [organization] = await transaction<{ base_currency_code: string }[]>`
        SELECT base_currency_code
        FROM organizations
        WHERE id = ${organizationId}::uuid
        LIMIT 1
      `;
      if (!organization) {
        throw new ApiError(404, 'ORGANIZATION_NOT_FOUND', 'المؤسسة غير موجودة.');
      }

      const currencies = await transaction<{ code: string; minor_unit: number }[]>`
        SELECT code, minor_unit
        FROM currencies
        WHERE code IN (${input.currencyCode}, ${organization.base_currency_code})
      `;
      const currencyMap = new Map(currencies.map((currency) => [currency.code, currency]));
      const sourceCurrency = currencyMap.get(input.currencyCode);
      const baseCurrency = currencyMap.get(organization.base_currency_code);
      if (!sourceCurrency || !baseCurrency) {
        throw new ApiError(422, 'CURRENCY_INVALID', 'العملة المحددة غير مدعومة.');
      }

      const baseAmountMinor = this.toBaseMinor(
        input.amountMinor,
        input.exchangeRate,
        sourceCurrency.minor_unit,
        baseCurrency.minor_unit,
      );
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
        WHERE customer_id = ${customerId}::uuid
      `;
      if (BigInt(ledger?.balance ?? '0') < BigInt(baseAmountMinor)) {
        throw new ApiError(409, 'CUSTOMER_PAYMENT_EXCEEDS_DEBT', 'مبلغ السداد يتجاوز دين العميل الحالي.');
      }

      const [payment] = await transaction<{
        id: string;
        received_at: Date;
      }[]>`
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
          NULL,
          ${input.method},
          ${input.amountMinor},
          ${input.currencyCode},
          ${input.exchangeRate}::numeric,
          ${baseAmountMinor},
          now(),
          ${userId}::uuid
        )
        RETURNING id, received_at
      `;
      if (!payment) {
        throw new ApiError(500, 'CUSTOMER_PAYMENT_FAILED', 'تعذر تسجيل سداد العميل.');
      }

      await transaction`
        INSERT INTO customer_ledger_entries (
          organization_id,
          customer_id,
          payment_id,
          entry_type,
          amount_base_minor,
          occurred_at,
          created_by
        )
        VALUES (
          ${organizationId}::uuid,
          ${customerId}::uuid,
          ${payment.id}::uuid,
          'credit',
          ${baseAmountMinor},
          now(),
          ${userId}::uuid
        )
      `;

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
          'customer.payment.recorded',
          'payment',
          ${payment.id}::uuid,
          ${JSON.stringify({ customerId, amountMinor: input.amountMinor, baseAmountMinor })}::jsonb
        )
      `;

      return {
        id: payment.id,
        customerId,
        amountMinor: input.amountMinor,
        baseAmountMinor,
        currencyCode: input.currencyCode,
        receivedAt: payment.received_at.toISOString(),
      };
    });
  }

  private toBaseMinor(
    amountMinor: number,
    rate: string,
    sourceMinorUnit: number,
    baseMinorUnit: number,
  ): number {
    const [whole, fraction = ''] = rate.split('.');
    const normalized = `${whole}${fraction.padEnd(12, '0')}`;
    const numerator = BigInt(amountMinor) * BigInt(normalized) * BigInt(10 ** baseMinorUnit);
    const denominator = BigInt(10 ** sourceMinorUnit) * 1_000_000_000_000n;
    const result = (numerator + denominator / 2n) / denominator;
    if (result > BigInt(Number.MAX_SAFE_INTEGER)) {
      throw new ApiError(422, 'AMOUNT_OUT_OF_RANGE', 'قيمة المبلغ خارج النطاق المدعوم.');
    }
    return Number(result);
  }

  private toCustomer(customer: CustomerRow) {
    return {
      id: customer.id,
      name: customer.name,
      phone: customer.phone_e164,
      creditLimitMinor: customer.credit_limit_minor,
      version: customer.version,
    };
  }
}
