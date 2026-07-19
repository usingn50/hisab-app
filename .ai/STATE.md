# STATE

Current task: none (idle — awaiting next task selection)
Progress: 100% (last task complete, merged with parallel session)
Last completed task: Merged conflicting parallel work from another AI
  session ("Manus", commit a1c8b4d) that independently fixed the same
  profit/loss color bug. Resolved in favor of design tokens + agreed
  brand blue (#3B82F6). See CHANGELOG for details.
Next task: Backend OTP integration (login_screen.dart, otp_screen.dart, data/remote/api_client.dart)
Files expected to be modified next:
- lib/data/remote/api_client.dart
- lib/presentation/screens/auth/login_screen.dart
- lib/presentation/screens/auth/otp_screen.dart
- lib/core/services/session_service.dart (possibly, if backend issues its own userId)

SafeToContinue: true

## ⚠️ Multi-session coordination
This repo has been worked on by more than one AI session/tool in parallel
(this assistant + a separate "Manus" session), causing a real merge
conflict on 2026-07-19. Before starting work:
1. `git pull` first, always.
2. Re-read this file — if `Current task` is not "none" and was updated
   very recently, another session may be actively working. Confirm with
   the user before starting overlapping work.
3. If you finish work, update this file and push promptly so the next
   session (any tool) sees accurate state instead of stale info.

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
