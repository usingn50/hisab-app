# CHANGELOG

## 2026-07-19
- Added hand-authored drift `.g.dart` bridge (app_database, 3 DAOs) — temporary until build_runner runs locally
- Redesigned login_screen.dart (animated entrance, ambient gradient, elevated card)
- Implemented PDF export (PdfReportService, Arabic RTL, wired into reports_screen.dart)
- Migrated brand color primary green -> blue; decoupled success (green) from primary
- Fixed credit score gauge and profit/loss chart color regressions from the migration
- Implemented SessionService + currentUserIdProvider; replaced hardcoded 'local-user' in 9 screens
- Implemented logout flow (settings_screen.dart, /settings route, dashboard entry point)
- Adopted AI Engineering Protocol; migrated HANDOVER.md into .ai/STATE.md, .ai/TODO.md, .ai/CHANGELOG.md
