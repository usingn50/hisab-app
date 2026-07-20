# TODO

- [x] Drift codegen bridge (.g.dart hand-authored until build_runner runs locally)
- [x] Login screen redesign
- [x] Brand color migration (green -> blue/gold, success decoupled from primary)
- [x] PDF export (reports_screen.dart)
- [x] Session Management (SessionService + currentUserIdProvider)
- [x] Logout flow (settings_screen.dart)
- [x] Backend OTP integration (AuthRepository + sealed results + dev/prod toggle via _backendEnabled)
- [x] Credit score share_token generation + share screen (credit_screen.dart:161)
- [x] Barcode scanner activation (mobile_scanner is in pubspec, unused — add_product_screen.dart:46)
- [ ] App icon asset generation (png/adaptive icon files; color direction decided: gold/blue, simplified mark, no text)
- [ ] Replace hand-authored .g.dart with real build_runner output (run locally, verify no diffs break repositories)
- [ ] PDF export real-device verification (untested — sandbox has no Flutter runtime)
- [x] users table integration (drift `users` table exists in schema but has no DAO/repository; session currently lives only in SharedPreferences)
- [ ] Business info edit UI (settings_screen currently shows businessName read-only; users table has businessName/businessType/city with placeholder defaults "متجري"/"عام"/"—" set at ensureExists() — needs an edit form + userRepositoryProvider.updateBusinessInfo() call)
