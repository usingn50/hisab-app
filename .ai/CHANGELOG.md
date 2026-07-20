# CHANGELOG

## 2026-07-19 (session 5)
- Generated app icon programmatically (Python/PIL — no external design tool
  available in sandbox): white receipt card + gold checkmark badge on a
  navy-to-blue diagonal gradient, matching splash_screen.dart colors exactly
  (background 0xFF0F172A -> primaryDark 0xFF1D4ED8, badge gold 0xFFEAB308).
  No text, per decided direction in TODO.md.
- Replaced all Android legacy mipmap ic_launcher.png (mdpi..xxxhdpi)
- Added Android adaptive icon: ic_launcher_foreground/background per density
  + mipmap-anydpi-v26/ic_launcher.xml (was completely absent — app had no
  adaptive icon support before this, only fell back to flat legacy icon)
- Replaced all iOS AppIcon.appiconset PNGs (20pt..1024pt); flattened to RGB
  (no alpha) per App Store requirement — source master had transparency
- Replaced web/icons (192, 512, maskable variants) and web/favicon.png
- Design is a placeholder-quality vector-style mark; a professional
  designer pass is still recommended before public store submission, but
  every icon slot in the repo is now populated with an on-brand asset
  instead of Flutter's default icon

## 2026-07-19 (session 4)
- Added AppUser entity, UserRepository interface, UserRepositoryImpl
- Added UserDao (+ hand-authored user_dao.g.dart mixin, matches existing DAO pattern)
- Wired userDaoProvider / userRepositoryProvider into injection.dart
- Wired ensureExists(phone) into OTP success flow — creates users row on
  first login only, phone used as id (matches existing userId convention),
  wrapped in try/catch so a users-table failure never blocks login
- Chose placeholder defaults (businessName="متجري", businessType="عام",
  city="—") over building an onboarding screen — kept migration risk low;
  full edit UI is a separate follow-up task (added to TODO)
- settings_screen now shows real businessName (falls back to static label
  while loading/null) — first visible proof the users table is live
- Fixed 2 pre-existing bugs found while editing otp_screen.dart: duplicate
  app_colors.dart import, dead SessionService import (session moved to
  AuthRepository in session 2 but import was never cleaned up)

## 2026-07-19 (session 3)
- Implemented CreditShareService: local base64 share_token, 7-day TTL, no backend dependency
- Credit screen: WhatsApp share, copy-link, locked-state card for <3 months users
- Clear share_token on logout
- Implemented BarcodeScannerScreen using mobile_scanner (viewfinder overlay, torch toggle, error states)
- Wired add_product_screen._scanBarcode to real camera + duplicate-barcode check via getByBarcode
- Added /barcode-scanner route to app.dart
- Added missing CAMERA permission to AndroidManifest.xml (mobile_scanner would have crashed at runtime without it)
- Added missing NSCameraUsageDescription to iOS Info.plist (App Store submission blocker without it)

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
- Merged conflicting parallel commit from another AI session ("Manus", a1c8b4d) — resolved in favor of AppColors design tokens over raw hex, kept agreed primary blue (#3B82F6)
- Added README.md notice directing any AI/automated tool to .ai/STATE.md before making changes
