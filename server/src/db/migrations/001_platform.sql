CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE member_role AS ENUM ('owner', 'manager', 'cashier', 'accountant', 'viewer');
CREATE TYPE invoice_status AS ENUM ('draft', 'issued', 'voided', 'refunded');
CREATE TYPE payment_method AS ENUM ('cash', 'credit', 'bank_transfer', 'wallet');
CREATE TYPE stock_reason AS ENUM ('sale', 'refund', 'adjustment', 'opening_balance');
CREATE TYPE mutation_status AS ENUM ('applied', 'duplicate', 'conflict', 'rejected');
CREATE TYPE change_operation AS ENUM ('upsert', 'tombstone');

CREATE TABLE IF NOT EXISTS schema_migrations (
  version TEXT PRIMARY KEY,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone_e164 TEXT NOT NULL UNIQUE,
  display_name TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE organizations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL CHECK (char_length(trim(name)) BETWEEN 2 AND 120),
  base_currency_code CHAR(3) NOT NULL DEFAULT 'YER',
  timezone TEXT NOT NULL DEFAULT 'Asia/Aden',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE organization_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  role member_role NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (organization_id, user_id)
);

CREATE TABLE branches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  name TEXT NOT NULL CHECK (char_length(trim(name)) BETWEEN 2 AND 120),
  city TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (organization_id, name)
);

CREATE TABLE currencies (
  code CHAR(3) PRIMARY KEY,
  name TEXT NOT NULL,
  minor_unit SMALLINT NOT NULL CHECK (minor_unit BETWEEN 0 AND 6),
  is_active BOOLEAN NOT NULL DEFAULT true
);

INSERT INTO currencies (code, name, minor_unit)
VALUES
  ('YER', 'Yemeni Rial', 2),
  ('USD', 'US Dollar', 2),
  ('SAR', 'Saudi Riyal', 2)
ON CONFLICT (code) DO NOTHING;

ALTER TABLE organizations
  ADD CONSTRAINT organizations_base_currency_fk
  FOREIGN KEY (base_currency_code) REFERENCES currencies(code) ON DELETE RESTRICT;

CREATE TABLE exchange_rates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  from_currency_code CHAR(3) NOT NULL REFERENCES currencies(code) ON DELETE RESTRICT,
  to_currency_code CHAR(3) NOT NULL REFERENCES currencies(code) ON DELETE RESTRICT,
  rate NUMERIC(28,12) NOT NULL CHECK (rate > 0),
  effective_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_by UUID REFERENCES users(id) ON DELETE RESTRICT,
  CHECK (from_currency_code <> to_currency_code)
);

CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  name TEXT NOT NULL CHECK (char_length(trim(name)) BETWEEN 1 AND 200),
  sku TEXT,
  barcode TEXT,
  sell_price_minor BIGINT NOT NULL CHECK (sell_price_minor >= 0),
  currency_code CHAR(3) NOT NULL REFERENCES currencies(code) ON DELETE RESTRICT,
  min_stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (min_stock_quantity >= 0),
  is_active BOOLEAN NOT NULL DEFAULT true,
  version BIGINT NOT NULL DEFAULT 1 CHECK (version > 0),
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX products_organization_sku_unique
  ON products (organization_id, sku)
  WHERE sku IS NOT NULL AND deleted_at IS NULL;

CREATE UNIQUE INDEX products_organization_barcode_unique
  ON products (organization_id, barcode)
  WHERE barcode IS NOT NULL AND deleted_at IS NULL;

CREATE TABLE customers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  name TEXT NOT NULL CHECK (char_length(trim(name)) BETWEEN 1 AND 200),
  phone_e164 TEXT,
  credit_limit_minor BIGINT CHECK (credit_limit_minor IS NULL OR credit_limit_minor >= 0),
  version BIGINT NOT NULL DEFAULT 1 CHECK (version > 0),
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX customers_organization_name_index
  ON customers (organization_id, name)
  WHERE deleted_at IS NULL;

CREATE INDEX customers_organization_phone_index
  ON customers (organization_id, phone_e164)
  WHERE phone_e164 IS NOT NULL AND deleted_at IS NULL;

CREATE TABLE invoices (
  id UUID PRIMARY KEY,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE RESTRICT,
  customer_id UUID REFERENCES customers(id) ON DELETE RESTRICT,
  status invoice_status NOT NULL DEFAULT 'draft',
  currency_code CHAR(3) NOT NULL REFERENCES currencies(code) ON DELETE RESTRICT,
  exchange_rate NUMERIC(28,12) NOT NULL CHECK (exchange_rate > 0),
  subtotal_minor BIGINT NOT NULL DEFAULT 0 CHECK (subtotal_minor >= 0),
  total_minor BIGINT NOT NULL DEFAULT 0 CHECK (total_minor >= 0),
  base_total_minor BIGINT NOT NULL DEFAULT 0 CHECK (base_total_minor >= 0),
  issued_at TIMESTAMPTZ,
  voided_at TIMESTAMPTZ,
  version BIGINT NOT NULL DEFAULT 1 CHECK (version > 0),
  deleted_at TIMESTAMPTZ,
  created_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK ((status = 'issued') = (issued_at IS NOT NULL)),
  CHECK ((status = 'voided') = (voided_at IS NOT NULL))
);

CREATE TABLE invoice_lines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id UUID NOT NULL REFERENCES invoices(id) ON DELETE RESTRICT,
  product_id UUID REFERENCES products(id) ON DELETE RESTRICT,
  description_snapshot TEXT NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  unit_price_minor BIGINT NOT NULL CHECK (unit_price_minor >= 0),
  line_total_minor BIGINT NOT NULL CHECK (line_total_minor >= 0),
  base_line_total_minor BIGINT NOT NULL CHECK (base_line_total_minor >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (line_total_minor = unit_price_minor * quantity)
);

CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  invoice_id UUID NOT NULL REFERENCES invoices(id) ON DELETE RESTRICT,
  method payment_method NOT NULL,
  amount_minor BIGINT NOT NULL CHECK (amount_minor > 0),
  currency_code CHAR(3) NOT NULL REFERENCES currencies(code) ON DELETE RESTRICT,
  exchange_rate NUMERIC(28,12) NOT NULL CHECK (exchange_rate > 0),
  base_amount_minor BIGINT NOT NULL CHECK (base_amount_minor > 0),
  received_at TIMESTAMPTZ NOT NULL,
  received_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE stock_movements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE RESTRICT,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
  invoice_line_id UUID REFERENCES invoice_lines(id) ON DELETE RESTRICT,
  quantity_delta INTEGER NOT NULL CHECK (quantity_delta <> 0),
  reason stock_reason NOT NULL,
  occurred_at TIMESTAMPTZ NOT NULL,
  created_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE customer_ledger_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
  invoice_id UUID REFERENCES invoices(id) ON DELETE RESTRICT,
  payment_id UUID REFERENCES payments(id) ON DELETE RESTRICT,
  entry_type TEXT NOT NULL CHECK (entry_type IN ('debit', 'credit', 'refund', 'adjustment')),
  amount_base_minor BIGINT NOT NULL CHECK (amount_base_minor > 0),
  occurred_at TIMESTAMPTZ NOT NULL,
  created_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK ((invoice_id IS NOT NULL) OR (payment_id IS NOT NULL) OR entry_type = 'adjustment')
);

CREATE TABLE client_mutations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  device_id UUID NOT NULL,
  mutation_id UUID NOT NULL,
  request_hash TEXT NOT NULL,
  operation TEXT NOT NULL,
  status mutation_status NOT NULL,
  result_json JSONB NOT NULL,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (organization_id, device_id, mutation_id)
);

CREATE TABLE change_log (
  sequence BIGSERIAL PRIMARY KEY,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  entity_type TEXT NOT NULL,
  entity_id UUID NOT NULL,
  operation change_operation NOT NULL,
  entity_version BIGINT NOT NULL CHECK (entity_version > 0),
  payload JSONB NOT NULL,
  changed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE audit_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  actor_user_id UUID REFERENCES users(id) ON DELETE RESTRICT,
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id UUID,
  before_data JSONB,
  after_data JSONB,
  request_id UUID,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX exchange_rates_lookup_index
  ON exchange_rates (organization_id, from_currency_code, to_currency_code, effective_at DESC);
CREATE INDEX invoices_organization_branch_issued_index
  ON invoices (organization_id, branch_id, issued_at DESC)
  WHERE deleted_at IS NULL;
CREATE INDEX invoice_lines_invoice_index ON invoice_lines (invoice_id);
CREATE INDEX payments_invoice_index ON payments (invoice_id);
CREATE INDEX stock_movements_product_branch_index
  ON stock_movements (product_id, branch_id, occurred_at DESC);
CREATE INDEX customer_ledger_customer_index
  ON customer_ledger_entries (customer_id, occurred_at DESC);
CREATE INDEX change_log_organization_sequence_index
  ON change_log (organization_id, sequence);
CREATE INDEX audit_events_organization_occurred_index
  ON audit_events (organization_id, occurred_at DESC);

CREATE OR REPLACE FUNCTION set_updated_at_and_version()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  IF TG_TABLE_NAME IN ('products', 'customers', 'invoices') THEN
    NEW.version = OLD.version + 1;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_set_updated_at
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION set_updated_at_and_version();

CREATE TRIGGER organizations_set_updated_at
BEFORE UPDATE ON organizations
FOR EACH ROW EXECUTE FUNCTION set_updated_at_and_version();

CREATE TRIGGER organization_members_set_updated_at
BEFORE UPDATE ON organization_members
FOR EACH ROW EXECUTE FUNCTION set_updated_at_and_version();

CREATE TRIGGER branches_set_updated_at
BEFORE UPDATE ON branches
FOR EACH ROW EXECUTE FUNCTION set_updated_at_and_version();

CREATE TRIGGER products_set_updated_at_and_version
BEFORE UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION set_updated_at_and_version();

CREATE TRIGGER customers_set_updated_at_and_version
BEFORE UPDATE ON customers
FOR EACH ROW EXECUTE FUNCTION set_updated_at_and_version();

CREATE TRIGGER invoices_set_updated_at_and_version
BEFORE UPDATE ON invoices
FOR EACH ROW EXECUTE FUNCTION set_updated_at_and_version();
