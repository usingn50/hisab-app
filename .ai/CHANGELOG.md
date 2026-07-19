# CHANGELOG

## 2026-07-19 (session 2)
- Implemented AuthRepository with sealed result types (SendOtpResult, VerifyOtpResult)
- Added dev/prod toggle (_backendEnabled flag) — flip to true after backend deploy
- Dev OTP hardcoded as 123456 with banner in otp_screen.dart
- Wired login_screen.dart and otp_screen.dart to AuthRepository (removed all TODO placeholders)
- Added authRepositoryProvider to injection.dart
- Migrated LoginScreen to ConsumerStatefulWidget

## 2026-07-19 (session 1)
- Added hand-authored drift `.g.dart` bridge (app_database, 3 DAOs) — temporary until build_runner runs locally
- Redesigned login_screen.dart (animated entrance, ambient gradient, elevated card)
- Implemented PDF export (PdfReportService, Arabic RTL, wired into reports_screen.dart)
- Migrated brand color primary green -> blue; decoupled success (green) from primary
- Fixed credit score gauge and profit/loss chart color regressions from the migration
- Implemented SessionService + currentUserIdProvider; replaced hardcoded 'local-user' in 9 screens
- Implemented logout flow (settings_screen.dart, /settings route, dashboard entry point)
- Adopted AI Engineering Protocol; migrated HANDOVER.md into .ai/STATE.md, .ai/TODO.md, .ai/CHANGELOG.md
