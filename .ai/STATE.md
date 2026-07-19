# STATE

Current task: none (idle — awaiting next task selection)
Progress: 100% (last task complete)
Last completed task: Backend OTP integration (AuthRepository + sealed results + dev/prod toggle)
Next task: Credit score share_token generation + share screen (credit_screen.dart:161)
Files expected to be modified next:
- lib/presentation/screens/credit/credit_screen.dart
- lib/data/remote/api_client.dart (generateShareLink already exists)
- lib/presentation/providers/injection.dart (add shareTokenProvider)

SafeToContinue: true

## Architecture guardrails (do not violate)
- `success` (green) is intentionally decoupled from `primary` (blue) in
  app_colors.dart — profit/loss semantics must stay green/red regardless
  of brand color. Do not merge them again.
- `userId` = phone number string (no backend-issued UUID yet). Treat as
  opaque string, not a UUID format, until backend OTP task lands.
- Logout clears SharedPreferences session only — local drift DB data is
  intentionally preserved (same phone number restores same data).
- AuthRepository._backendEnabled = false (dev mode). Set to true only
  after backend Node.js is deployed and ApiClient.baseUrl is updated.
- Dev OTP = 123456 — shown to user in otp_screen.dart dev banner.
  Remove banner when _backendEnabled = true.

## Environment note
No Flutter/Dart SDK available in the AI sandbox (no pub.dev access). All
verification here is manual (brace/paren balance + code review), not a real
`flutter analyze`/`build_runner` run. Run build_runner locally before trusting
`lib/data/local/database/app_database.g.dart` and the DAO `.g.dart` files —
they were hand-authored as a temporary bridge.
