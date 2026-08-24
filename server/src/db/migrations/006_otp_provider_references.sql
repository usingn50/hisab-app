ALTER TABLE otp_challenges
  ADD COLUMN IF NOT EXISTS provider text NOT NULL DEFAULT 'development',
  ADD COLUMN IF NOT EXISTS provider_reference text;

ALTER TABLE otp_challenges
  ALTER COLUMN code_hash DROP NOT NULL;

CREATE INDEX IF NOT EXISTS otp_challenges_provider_reference_idx
  ON otp_challenges (provider_reference)
  WHERE provider_reference IS NOT NULL;
