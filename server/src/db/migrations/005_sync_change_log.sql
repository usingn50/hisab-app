CREATE TABLE sync_bootstraps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  device_id UUID NOT NULL,
  high_watermark_sequence BIGINT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (expires_at > created_at)
);

CREATE INDEX sync_bootstraps_scope_index
  ON sync_bootstraps (organization_id, device_id, expires_at DESC);

CREATE OR REPLACE FUNCTION append_sync_change()
RETURNS TRIGGER AS $$
DECLARE
  record_data JSONB;
  entity_uuid UUID;
  organization_uuid UUID;
  entity_version BIGINT;
  operation_value change_operation;
BEGIN
  IF TG_OP = 'DELETE' THEN
    record_data := to_jsonb(OLD);
    operation_value := 'tombstone';
  ELSE
    record_data := to_jsonb(NEW);
    operation_value := 'upsert';
  END IF;

  entity_uuid := COALESCE(record_data ->> 'id', record_data ->> 'product_id')::uuid;
  organization_uuid := (record_data ->> 'organization_id')::uuid;
  entity_version := COALESCE((record_data ->> 'version')::bigint, 1);

  INSERT INTO change_log (
    organization_id,
    entity_type,
    entity_id,
    operation,
    entity_version,
    payload
  )
  VALUES (
    organization_uuid,
    TG_TABLE_NAME,
    entity_uuid,
    operation_value,
    entity_version,
    record_data
  );

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER products_append_sync_change
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW EXECUTE FUNCTION append_sync_change();

CREATE TRIGGER customers_append_sync_change
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW EXECUTE FUNCTION append_sync_change();

CREATE TRIGGER branches_append_sync_change
AFTER INSERT OR UPDATE OR DELETE ON branches
FOR EACH ROW EXECUTE FUNCTION append_sync_change();

CREATE TRIGGER invoices_append_sync_change
AFTER INSERT OR UPDATE OR DELETE ON invoices
FOR EACH ROW EXECUTE FUNCTION append_sync_change();

CREATE TRIGGER payments_append_sync_change
AFTER INSERT OR UPDATE OR DELETE ON payments
FOR EACH ROW EXECUTE FUNCTION append_sync_change();

CREATE TRIGGER stock_movements_append_sync_change
AFTER INSERT OR UPDATE OR DELETE ON stock_movements
FOR EACH ROW EXECUTE FUNCTION append_sync_change();

CREATE TRIGGER customer_ledger_entries_append_sync_change
AFTER INSERT OR UPDATE OR DELETE ON customer_ledger_entries
FOR EACH ROW EXECUTE FUNCTION append_sync_change();

CREATE TRIGGER exchange_rates_append_sync_change
AFTER INSERT OR UPDATE OR DELETE ON exchange_rates
FOR EACH ROW EXECUTE FUNCTION append_sync_change();

CREATE TRIGGER stock_balances_append_sync_change
AFTER INSERT OR UPDATE OR DELETE ON stock_balances
FOR EACH ROW EXECUTE FUNCTION append_sync_change();
