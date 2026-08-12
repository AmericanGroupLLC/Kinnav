# Testing — Kinnav app + website

Two codebases, two toolchains:

| | Website (`website/`) | Mobile app (repo root) |
|---|---|---|
| Unit / integration / functional | Vitest + Testing Library (`pnpm test`) | `flutter test` |
| Accessibility | axe-core in jsdom, plus axe in the browser suite | — |
| End-to-end | Playwright, `pnpm test:e2e` | widget tests drive the real screens |
| Server-side | php-wasm runs `api/contact.php` for real | — |
| Static analysis | `pnpm lint` | `flutter analyze` |
| Compile | `pnpm build` | `flutter build ios` / `flutter build apk` |

## Website

```bash
cd website
pnpm install
pnpm test            # unit + integration + a11y + PHP + build-output checks
pnpm test:coverage   # same, with a coverage summary
pnpm test:e2e        # Playwright: real browsers, needs one that can launch
pnpm lint
pnpm build
```

`pnpm test` covers eight files:

| File | What it proves |
|---|---|
| `src/lib/submitForm.test.js` | A submission is only reported as sent when the server accepted it; every failure mode falls back to `mailto:` |
| `src/pages/Contact.test.jsx` | The contact form submits, tags the subject per topic, validates, and never claims delivery it cannot vouch for |
| `src/pages/Waitlist.test.jsx` | Waitlist signup, role tagging, and the same honesty rule for its confirmation copy |
| `src/App.test.jsx` | Every route renders its page and not the 404; nav and footer link where they should; external links carry `rel="noopener"` |
| `src/test/a11y.test.jsx` | axe-core finds no critical or serious WCAG 2.1 AA violations on any page; one `h1` per page; images have alt text; controls have names |
| `src/test/php-handler.test.js` | `api/contact.php` executed for real (php-wasm, PHP 8.5): method/JSON/field/email/length validation, honeypot, header-injection attempts, rate limiting, no credentials |
| `src/test/build-output.test.js` | The built site served over HTTP: routes, assets, SEO tags, sitemap, size budgets, and every `.htaccess` rule the deploy depends on |
| `src/test/security.test.js` | No `dangerouslySetInnerHTML`/`eval`, no secrets in source or bundles, no source maps or config published, `/api` contains only the handler |

### What the PHP tests can and cannot show

php-wasm has no mail transport, so `mail()` always fails there. A request that
reaches the send stage returns 502, and the tests use that as the "accepted"
signal — it proves validation, the honeypot and the rate limiter all passed.
Actual delivery is verified against the live server with the `curl` command in
[`website/DEPLOY.md`](website/DEPLOY.md).

### Browser end-to-end suite

`e2e/` holds the Playwright suite: navigation and deep links, both forms end to
end, 404 handling, axe on a real engine (including colour contrast, which jsdom
cannot evaluate), no horizontal overflow at 375/768/1440 px, tap-target sizes,
FCP and transfer budgets, and SEO metadata. It runs on desktop Chromium and
mobile WebKit against `vite preview`.

```bash
cd website && pnpm test:e2e
```

## Mobile app

```bash
flutter pub get
flutter analyze
flutter test --coverage
flutter build ios --no-codesign     # device build, no signing
flutter build apk --debug
```

| File | What it proves |
|---|---|
| `test/models_test.dart` | Guardian initials and sample-network sanity; `CallRecord`/`SafetyContact` json round-trips and their fallbacks for partial stored data; every module and reward is presentable |
| `test/user_profile_test.dart` | Age, initials, json round-trip |
| `test/app_state_test.dart` | Persistence of profile, rewards, guardian course and call history |
| `test/config_test.dart` | With no `--dart-define`, every optional integration reports unavailable, the build is not "prod", and an emergency number still exists |
| `test/app_flow_test.dart` | The RootRouter gate: onboarding → sign-up → profile → map, demo mode, restart behaviour, and that the map's primary actions open |
| `test/security_test.dart` | No committed keys; JWTs never written through the prefs wrapper; every endpoint https; no cleartext traffic or relaxed ATS; the Android permission set is the reviewed one and every iOS permission explains itself; emergency dialling is only ever reachable through the confirmation dialog |
| `test/performance_test.dart` | Cold start and call-options open within budget, no animation that never settles, asset weight capped, collection screens build lazily |
| `test/accessibility_test.dart` | Android and iOS tap-target guidelines, every tappable labelled for screen readers, no layout overflow at 320pt, 834pt or 150% text |
| `test/widget_test.dart` | First run shows onboarding |

### Known environment limits

Two things cannot run inside a sandboxed shell and need a normal machine:

- **Browser end-to-end** (`pnpm test:e2e`). Chromium aborts at launch with
  `bootstrap_check_in ... Permission denied` and Firefox cannot create a page.
- **`flutter build apk`.** The Gradle daemon binds `127.0.0.1` and the client
  cannot connect to IPv4 loopback, so the build fails with "Could not connect to
  the Gradle daemon". `./gradlew --version` and `flutter build ios` both work,
  so this is the sandbox rather than the project.

### A pinned behaviour

`test/app_flow_test.dart` pins one behaviour worth knowing about: `AppState`'s
constructor reconciles the local `signedIn` flag against Supabase, so when
Supabase is unavailable (offline launch, misconfiguration, tests) a returning
user is signed out and routed back to sign-up. The profile and onboarding flag
survive. Change that reconciliation and the test will tell you.
