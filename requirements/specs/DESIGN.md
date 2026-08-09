# Kinnav — Design Document

The technical & product **design** for Kinnav — the "how it's built" companion to
`REQUIREMENTS.md` (what) and `PLAN.md` (when). Reflects the current codebase.

---

## 1. Overview

Kinnav is a cross-platform (iOS + Android) **Flutter** app: an all-in-one women's
**safety + empowerment + rewards** product. Users reach vetted **guardians** via a
map + a one-tap **Safe Call**; the same app carries self-care modules, rewards, and
community. The client is architected as a thin, backend-ready UI over a swappable
service layer so mock/offline today becomes the AmericanGroupLLC backend tomorrow
with no UI rework.

## 2. Architecture

Layered, dependency flows downward only:

```
screens/  ──▶ widgets/            (presentation)
   │           │
   ▼           ▼
app_state.dart (ChangeNotifier)   (state: single source of truth)
   │
   ▼
services/  ──▶ models/            (boundaries + domain types)
   │
   ▼
config/ + services/storage.dart   (build config + persistence)
```

- **UI never calls a backend directly.** Screens read `AppState` and call service
  interfaces. Swapping an implementation is a one-line change in `services/services.dart`.
- **`AppState`** is the only mutable, persisted app state; widgets rebuild via
  `ListenableBuilder`.
- **Services** are interfaces with mock implementations; real ones (Firebase, Agora,
  the API gateway) drop in behind the same contracts.

### Directory map (`lib/`)

```
main.dart                 App entry, error zone, RootRouter
app_state.dart            ChangeNotifier: session, profile, contacts, history, …
config/app_config.dart    Build-time config + feature flags (--dart-define)
models/                   guardian, user_profile, safety_contact, call_type, call_record, content
services/
  storage.dart            shared_preferences wrapper (non-secret prefs)
  secure_store.dart       flutter_secure_storage (JWTs — org policy)
  services.dart           ServiceLocator (mock ↔ real swap point)
  auth_service.dart       AuthService (OTP) + mock
  auth_api.dart           AmericanGroupLLC gateway auth (register/login/verify/me/logout)
  api_client.dart         HTTP client: Bearer + 401→refresh + {error} envelope
  guardian_service.dart   nearby guardians / presence
  call_service.dart       Safe Call session lifecycle
  location_service.dart   GPS via geolocator (+ fallback)
  notification_service.dart  guardian/contact alerts boundary
  purchase_service.dart   subscription purchase boundary
  links.dart              tel/sms/mailto/web launchers
  emergency.dart          confirmed emergency dialing
  analytics_service.dart  events + crash reporting boundary (no-op default)
theme/app_theme.dart      brand palette + ThemeData
widgets/                  avatar, map_view, live_map, coach_bubble, primary_button
screens/                  one file per screen (see §6)
```

## 3. State management

- **`AppState extends ChangeNotifier`** — the single source of truth. Getters are
  read-only (unmodifiable views); every mutation persists then `notifyListeners()`.
- Held state: `onboarded`, `signedIn`, `profile`, `contacts`, `redeemedRewards`,
  `completedModules`, `plan`, `callHistory`, `guardianCourseStep`, `guardianAvailable`.
- Exposed as a top-level `appState` (simple locator; can migrate to Provider/Riverpod
  later without touching call sites).
- Reactivity: screens wrap dynamic regions in `ListenableBuilder(listenable: appState)`.

## 4. Persistence

- **Non-secret** state → `Storage` (shared_preferences), JSON-encoded, namespaced keys
  (`onboarded`, `signedIn`, `profile`, `safetyContacts`, `redeemedRewards`,
  `completedModules`, `subscriptionPlan`, `callHistory`, `guardianCourseStep`,
  `guardianAvailable`).
- **Secrets (JWTs)** → `SecureStore` (iOS Keychain / Android Keystore) per
  AmericanGroupLLC policy — never in shared_preferences.

## 5. Service layer & backend strategy

Every external capability is an **interface** with a **mock** today:

| Boundary | Interface | Mock | Real (gated) |
|---|---|---|---|
| Auth | `AuthService` / `AuthApi` | `MockAuthService` | AmericanGroupLLC gateway / Firebase Phone OTP |
| Guardians | `GuardianService` | `MockGuardianService` | Firestore geo-queries |
| Safe Call | `CallService` | `MockCallService` | Agora RTC |
| Location | `LocationService` | fallback coords | `geolocator` GPS |
| Notifications | `NotificationService` | in-app | FCM/APNs |
| Purchases | `PurchaseService` | `MockPurchaseService` | `in_app_purchase` |
| Analytics | `AnalyticsService` | `NoopAnalyticsService` | Firebase/Sentry |

`services/services.dart` selects implementations from `AppConfig` (e.g.
`BACKEND=americangroupllc`, `AGORA_APP_ID`, `MAPS_API_KEY`). The API gateway base
URL and org credentials come from `AppConfig` (per the backend developer guide).

## 6. Navigation & screen flow

`RootRouter` (in `main.dart`) gates entry on persisted state:

```
!onboarded              → OnboardingScreen        (+ dev "Demo mode" shortcut)
onboarded & !signedIn   → SignUpScreen (18+ gate) (+ dev "Demo mode" shortcut)
signedIn & !hasProfile  → ProfileSetupScreen
else                    → HomeMapScreen (app root)
```

From **Home** (map + CALL GUARDIANS + drawer + chat):
- CALL GUARDIANS → `CallOptionsScreen` (Voice/Video/Text/Emergency, slide-to-activate)
  → `SafeCallScreen` (or `ChatScreen` for text).
- Drawer → Profile · Safety Contacts · Safe Call History · Self Care (→ Module detail)
  · Rewards · Membership · How-to-Use · Contact · Feedback · About (→ Legal/Privacy).

## 7. Domain models

`Guardian` (name, distance, languages, online, color, map position) ·
`UserProfile` (name, birth month/year, identity, languages, isGuardian; age +
initials helpers) · `SafetyContact` · `CallType` (voice/video/text/emergency) ·
`CallRecord` (type, guardians, duration, police, timestamp) · `Module` / `Reward`.
All persisted models implement `toJson`/`fromJson`.

## 8. Design system & brand

- **Palette** (`AppColors`): primary `#9B59D0`, primaryLight `#B57BE0`, primaryDark
  `#6A1B9A`, lavender surfaces `#F4ECFA`/`#EDE3F6`, semantic danger/online/pin.
  Signature `primaryGradient` (light→primary).
- **Theme**: Material 3, lavender scaffold, transparent flat app bars, tuned text theme.
- **Reusable components**:
  - `PrimaryButton` — signature gradient pill (CALL GUARDIANS).
  - `InitialsAvatar` — generated avatar (initials on gradient disc, optional online
    dot) — no bundled photos, works offline.
  - `MapView` — offline painted map (roads/parks/water/highways) + guardian glyph
    pins + user marker.
  - `LiveMap` — real `GoogleMap` when `MAPS_API_KEY` is set, else `MapView`.
  - `CoachBubble` — purple-outlined tooltip for onboarding/coach marks.
- **Logo/identity**: shield + crescent moon (night-safety), in `assets/logo/`
  (`kinnav_icon.svg`, `kinnav_logo.svg`); applied as the iOS/Android app icon.

## 9. Maps & location

`LocationService` (geolocator) requests permission and returns real coordinates,
falling back to a fixed location when denied/unavailable (simulator-safe). The map
is **gated**: `LiveMap` renders Google Maps only when a key is configured, so the app
always works — the painted `MapView` is the offline default. Native keys: iOS
`Info.plist` `GMSApiKey`, Android manifest placeholder `MAPS_API_KEY`.

## 10. Safe Call design

`SafeCallScreen` models a call as connecting → active: a 2s connect, live timer,
map ⇄ video-grid toggle, video/mute/speaker controls, confirmed **Add police**
(`Emergency.confirmAndDial`), and one-time coach marks (add police / switch view /
thank guardians). On connect it notifies persisted safety contacts; on hang-up it
appends a `CallRecord` to history.

## 11. Configuration & feature flags

`AppConfig` reads `--dart-define`s: `FLAVOR`, `BACKEND`, `MAPS_API_KEY`,
`AGORA_APP_ID`, `API_BASE_URL`, `EMERGENCY_NUMBER`, plus org defaults (gateway URL,
Supabase, Firebase project, client IDs). Feature flags derive from credential
presence: `hasMaps`, `hasVideo`, `hasBackend`, `isProd`.

## 12. Platform / native design

- **iOS**: programmatic `UIWindow` + explicit `FlutterEngine` in `AppDelegate`
  (no storyboard — the build host can't run `ibtool`); deployment target 15.0 for
  the Google Maps SDK; location usage strings in `Info.plist`.
- **Android**: `com.americangroupllc.kinnav`, location + internet permissions, Maps
  key via `manifestPlaceholders`, launcher icons generated from the logo master.
- **Bundle/app id**: `com.americangroupllc.kinnav` (matches org convention).

## 13. Security & privacy design

Tokens in secure enclaves (`SecureStore`); single HTTPS API gateway; auto token
refresh on 401; no PII/precise-location in analytics; in-app Legal Terms & Privacy
Policy screens (placeholder pending legal review — a launch gate in `PRODUCTION.md`).

## 14. Quality

Unit/widget tests (`test/`): `AppState` persistence & flows, `UserProfile` logic,
first-run routing. `flutter analyze` clean. GitHub Actions CI (`analyze` + `test` +
Android debug build). Crash/error routing via `runZonedGuarded` → `AnalyticsService`.

## 15. Cross-references

- `REQUIREMENTS.md` — functional/non-functional requirements
- `PLAN.md` — phased roadmap & status
- `PRODUCTION.md` — go-live runbook & legal/safety gate
- `../design-flow/` — annotated reference screens · `../../assets/logo/` — brand assets
