# STATE

Current task: UX operational-flow improvement batch
Progress: complete locally; awaiting commit and push of the extended batch

Last completed work:
- Added reusable Arabic search and currency-conversion components.
- Added search, filters, empty-result recovery, and action-oriented alerts to inventory and debt workflows.
- Added price-margin guidance to product entry and base-currency conversion feedback to sale and expense entry.
- Made confirmation labels describe the merchant action being saved.
- Made the OTP development hint conditional on the auth mode, and added one-time-code autofill plus automatic verification after six digits.
- Expanded settings into business, local-data, currency, and session sections without presenting inactive sync or backup capabilities as live.

Validation completed in this environment:
- `flutter analyze` passed.
- `flutter test` passed.
- `flutter build web --release --no-wasm-dry-run` passed.
- Browser preview reaches the authenticated dashboard route after the latest build.

Next UX priorities:
1. Add report-period controls and per-currency breakdowns once reporting aggregation supports them.
2. Complete secure production authentication and session storage only after deployed API contracts align with the Flutter client.
3. Add customer payment entry and product detail/edit flows before presenting those actions in list tiles.
4. Run device-level usability checks for barcode scanning, PDF sharing, keyboard behavior, and accessibility.

SafeToContinue: true

## Architecture guardrails
- Keep `success` green separate from the blue brand primary; profit and loss semantics must remain clear.
- `userId` is currently the phone-number string; do not assume a backend UUID until live API authentication is integrated.
- Local Drift data remains on device after logout by design.
- `AuthRepository._backendEnabled` remains false until the Node API is deployed and client contracts are aligned.
- Development OTP must never be represented as a production authentication flow.
- Financial summaries are normalized to the business base currency. Do not present mixed currency totals as a single raw amount.

## Coordination
- Pull before new work, re-read this file, and commit only deliberate changes.
- Do not commit generated build artifacts or accidental `.gitignore` changes caused by Flutter tooling.
