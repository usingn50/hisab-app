# STATE

Current task: UX operational-flow improvement batch
Progress: complete locally; awaiting commit and push

Last completed work:
- Added a reusable Arabic search field with a visible clear action and accessibility label.
- Added search, result states, and low-stock filtering to the inventory screen.
- Added search plus outstanding/overdue filters to the debt book.
- Improved product entry with Yemeni-rial suffixes, stock guidance, and a live per-unit margin preview.
- Improved sale entry with foreign-currency conversion feedback and payment-specific confirmation labels.

Validation completed in this environment:
- `flutter analyze` passed.
- `flutter test` passed.
- `flutter build web --release --no-wasm-dry-run` passed.

Next UX priorities:
1. Expand settings into clear business, data, security, and support sections without presenting unavailable cloud features as active.
2. Improve the production OTP experience only after the deployed API contract replaces development authentication.
3. Add period controls and per-currency breakdowns to financial reports after the reporting data layer exposes the required aggregation.
4. Run device-level usability checks for barcode scanning, PDF sharing, keyboard behavior, and accessibility.

SafeToContinue: true

## Architecture guardrails
- Keep `success` green separate from the blue brand primary; profit/loss semantics must remain clear.
- `userId` is currently the phone-number string; do not assume a backend UUID until live API authentication is integrated.
- Local Drift data remains on device after logout by design.
- `AuthRepository._backendEnabled` remains false until the Node API is deployed and client contracts are aligned.
- Development OTP must never be represented as a production authentication flow.
- Financial summaries are normalized to the business base currency. Do not present mixed currency totals as a single raw amount.

## Coordination
- Pull before new work, re-read this file, and commit only deliberate changes.
- Do not commit generated build artifacts or accidental `.gitignore` changes caused by Flutter tooling.
