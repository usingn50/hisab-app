# TODO

- [x] Drift codegen bridge (.g.dart hand-authored until build_runner runs locally)
- [x] Login screen redesign
- [x] Brand color migration (green -> blue/gold, success decoupled from primary)
- [x] PDF export (reports_screen.dart)
- [x] Session Management (SessionService + currentUserIdProvider)
- [x] Logout flow (settings_screen.dart)
- [ ] Backend OTP integration (real send/verify, currently simulated)
- [ ] Credit score share_token generation + share screen (credit_screen.dart:161)
- [ ] Barcode scanner activation (mobile_scanner is in pubspec, unused — add_product_screen.dart:46)
- [ ] App icon asset generation (png/adaptive icon files; color direction decided: gold/blue, simplified mark, no text)
- [ ] Replace hand-authored .g.dart with real build_runner output (run locally, verify no diffs break repositories)
- [ ] PDF export real-device verification (untested — sandbox has no Flutter runtime)
- [ ] users table integration (drift `users` table exists in schema but has no DAO/repository; session currently lives only in SharedPreferences)
