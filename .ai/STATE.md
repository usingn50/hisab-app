# STATE

Current task: none (idle — awaiting next task selection)
Progress: 100% (both sessions' work merged; TODO list nearly clear)
Last completed task: Business info edit UI (edit_business_screen.dart) —
  most recent commit from the parallel session, merged in cleanly.
  Combined with this session's work: OTP backend integration, share_token,
  barcode scanner, app icons, and users table DAO are ALL now done
  (see .ai/TODO.md — only two items remain unchecked).
Next task: pick one of the two remaining TODO items:
  1. Replace hand-authored .g.dart files with real build_runner output
     (needs the user to run it locally — not something an AI session can
     verify without a Flutter SDK)
  2. PDF export real-device verification (same constraint — needs a real
     device/emulator, not available in this sandbox)
  Both are effectively blocked on the user running Flutter locally, so
  functionally there is no fully AI-executable task left in the backlog.
  Confirm with the user before inventing new scope.
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
