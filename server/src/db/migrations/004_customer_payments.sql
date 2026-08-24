ALTER TABLE payments
  ALTER COLUMN invoice_id DROP NOT NULL;

CREATE INDEX payments_customer_settlement_index
  ON payments (organization_id, received_at DESC)
  WHERE invoice_id IS NULL;
