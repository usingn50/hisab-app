# STATE

Current task: none (idle — awaiting next task selection)
Progress: 100% (last task complete)
Last completed task: Logout flow (settings_screen.dart, session clear, /settings route)
Next task: Backend OTP integration (login_screen.dart, otp_screen.dart, data/remote/api_client.dart)
Files expected to be modified next:
- lib/data/remote/api_client.dart
- lib/presentation/screens/auth/login_screen.dart
- lib/presentation/screens/auth/otp_screen.dart
- lib/core/services/session_service.dart (possibly, if backend issues its own userId)

SafeToContinue: true

## Architecture guardrails (do not violate)
- `success` (green) is intentionally decoupled from `primary` (blue) in
  app_colors.dart — profit/loss semantics must stay green/red regardless
  of brand color. Do not merge them again.
- `userId` = phone number string (no backend-issued UUID yet). Treat as
  opaque string, not a UUID format, until backend OTP task lands.
- Logout clears SharedPreferences session only — local drift DB data is
  intentionally preserved (same phone number restores same data).

## Environment note
No Flutter/Dart SDK available in the AI sandbox (no pub.dev access). All
verification here is manual (brace/paren balance + code review), not a real
`flutter analyze`/`build_runner` run. Run build_runner locally before trusting
`lib/data/local/database/app_database.g.dart` and the DAO `.g.dart` files —
they were hand-authored as a temporary bridge.
