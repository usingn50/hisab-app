# STATE

Current task: none (idle — awaiting next task selection)
Progress: 100% (TODO list clear except two locally-blocked items)
Last completed task: Deep code review of the parallel session's merged
  work (AuthRepository, user DAO/repo/entity, CreditShareService,
  barcode_scanner_screen, edit_business_screen) — traced every new
  integration point (routes, providers, string constants, schema field
  matches, permission manifests). No bugs found; code quality is solid
  (proper error handling, idempotent ensureExists, correct provider
  invalidation on business info edit, logout correctly clears both
  session and credit share token).
Next task: none identified that doesn't require local Flutter tooling.
  Remaining backlog (see .ai/TODO.md) is blocked on the user running
  build_runner and testing PDF on a real device. Do not invent new scope
  without confirming with the user first.
Files expected to be modified next: none confirmed yet — see Next task above,
awaiting user decision on scope since remaining items need local Flutter tooling.

SafeToContinue: true

## ⚠️ Multi-session coordination
This repo was worked on by more than one AI session/tool in parallel on
2026-07-19, causing two real merge conflicts. User has since confirmed
only this session will continue working on the repo — the "multiple
tools in parallel" risk below is now historical, but the checklist habits
are still good practice:
1. `git pull` first, always.
2. Re-read this file before starting new work.
3. Update this file and push promptly after finishing work.

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
