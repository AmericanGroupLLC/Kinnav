# AGENTS.md — Kinnav (AI orientation)

> Read this first. It's the fast, token-cheap map of the app so you can act without
> scanning the whole tree. Deep detail: `requirements/specs/DESIGN.md`.

## What
**Kinnav** — Flutter (iOS + Android) women's **safety + empowerment + rewards** app.
Users reach vetted **guardians** via a map + one-tap **Safe Call**; plus self-care
modules, rewards, community. Bundle id `com.americangroupllc.kinnav`. Brand: purple
(`#9B59D0`), shield + crescent-moon logo.

## Run
```
flutter pub get
flutter run -d <device>
# flags: --dart-define=MAPS_API_KEY=… AGORA_APP_ID=… BACKEND=americangroupllc EMERGENCY_NUMBER=911
```
Entry: `lib/main.dart` → `RootRouter` picks the screen from `AppState`.

## Architecture (one line)
`screens → widgets → AppState (ChangeNotifier) → services (interfaces+mocks) → config + storage`.
UI never calls a backend directly. Swap mock→real in `lib/services/services.dart`.

## File map (`lib/`) — path → responsibility
| Path | Responsibility |
|---|---|
| `main.dart` | Entry; `runZonedGuarded`; `RootRouter` gates by session |
| `app_state.dart` | `AppState` ChangeNotifier + global `appState`; all state + persistence; `enterDemoMode()` |
| `config/app_config.dart` | `AppConfig`: `--dart-define` config + flags `hasMaps/hasVideo/hasBackend/isProd` |
| `theme/app_theme.dart` | `AppColors`, `AppTheme` (brand palette, M3) |
| `models/guardian.dart` | `Guardian` + `kGuardians` sample list |
| `models/user_profile.dart` | `UserProfile` (age/initials, json) |
| `models/safety_contact.dart` | `SafetyContact` |
| `models/call_type.dart` | `CallType` enum (voice/video/text/emergency) |
| `models/call_record.dart` | `CallRecord` (Safe Call history entry) |
| `models/content.dart` | `Module`,`Reward` + `kModules`,`kRewards` |
| `services/storage.dart` | shared_preferences wrapper (non-secret) |
| `services/secure_store.dart` | Keychain/Keystore for JWTs (org policy) |
| `services/services.dart` | **ServiceLocator** — mock↔real swap point |
| `services/auth_service.dart` | `SupabaseAuthService` — **real** Supabase auth |
| `services/guardian_service.dart` | `GuardianService` + `MockGuardianService` (sample data) |
| `services/supabase_guardian_service.dart` | real roster from the Supabase `guardians` table |
| `services/call_service.dart` | `CallService` + `MockCallService`; drives the demo disclosure |
| `services/call_token_client.dart` | fetches a short-lived call token from the Kinnav API |
| `services/location_service.dart` | `LocationService` (geolocator + fallback) |
| `services/purchase_service.dart` | `MockPurchaseService` — not wired to a store |
| `services/emergency.dart` | `Emergency.confirmAndDial` (confirmed 911) |
| `services/links.dart` | tel/sms/mailto/web launchers |
| `services/emergency.dart` | `Emergency.confirmAndDial` (confirmed 911) |
| `services/analytics_service.dart` | events + crash boundary (`analytics`, no-op) |
| `services/links.dart` | tel/sms/mailto/web launchers |
| `widgets/avatar.dart` | `InitialsAvatar` (generated, offline) |
| `widgets/map_view.dart` | `MapView` painted offline map + pins |
| `widgets/live_map.dart` | `LiveMap` = GoogleMap if key else `MapView` |
| `widgets/coach_bubble.dart` | `CoachBubble` tooltip |
| `widgets/primary_button.dart` | `PrimaryButton` gradient pill |

### `lib/screens/`
`onboarding` · `sign_up` (18+ gate) · `profile_setup` · `home_map` (root) ·
`call_options` (Voice/Video/Text/Emergency, slide) · `safe_call` · `menu_drawer` ·
`chat` · `guardians` · `guardian_course` (40h) · `modules` · `module_detail` ·
`rewards` · `subscription` · `profile` · `safety_contacts` · `feedback` · `about` ·
`legal` · `call_history`.

## Flow
```
main → RootRouter:
  !onboarded  → OnboardingScreen   (dev: "Demo mode" → enterDemoMode)
  !signedIn   → SignUpScreen
  !hasProfile → ProfileSetupScreen
  else        → HomeMapScreen
HomeMap: drawer(MenuDrawer) + CALL GUARDIANS → CallOptionsScreen → SafeCallScreen | ChatScreen
Drawer → Profile · SafetyContacts · CallHistory · Modules→ModuleDetail · Rewards ·
         Subscription · HowToUse · Contact · Feedback · About→Legal
```

## AppState (single source of truth)
Fields (persist key): `onboarded`,`signedIn`,`profile`,`contacts(safetyContacts)`,
`redeemedRewards`,`completedModules`,`plan(subscriptionPlan)`,`callHistory`,
`guardianCourseStep`,`guardianAvailable`. Secrets (JWT) → `SecureStore`, not here.
Mutate → persist → `notifyListeners()`. Read in UI via `ListenableBuilder(listenable: appState)`.

## What is real and what is not — read before promising anything

A default `flutter build` produces a **demo**. This table is the honest state;
the previous version described an architecture that did not exist.

| Capability | Today | To make it real |
|---|---|---|
| Auth | **real** — Supabase, live project in `AppConfig` | nothing; already wired |
| Location | **real** — geolocator GPS | nothing |
| Guardians | sample list; `SupabaseGuardianService` is written and waiting | create the `guardians` table (schema in that file), build with `--dart-define=BACKEND=americangroupllc` |
| Safe Call | **simulated** — `MockCallService`; no RTC package exists | token fetch is built (`CallTokenClient`); still needs an RTC package and a `CallService` with `isSimulated => false` |
| Maps | painted offline map | `--dart-define=MAPS_API_KEY=…` |
| Purchases | `MockPurchaseService` | `in_app_purchase` + store products |
| Notifications | none | FCM/APNs |
| Analytics | no-op boundary | Firebase/Sentry behind `analytics` |

`ServiceLocator` (`lib/services/services.dart`) is the single swap point.
`services.guardiansAreSample` is true whenever the people on screen are not
real responders.

## Where to change X
| Task | Edit |
|---|---|
| Brand colors/theme | `theme/app_theme.dart` (`AppColors`) |
| Add a persisted field | `app_state.dart` (key + `_load` + getter + mutation) |
| Add/route a screen | `screens/…` + `screens/menu_drawer.dart` or `main.dart` router |
| Wire a real backend | `services/services.dart` + `AppConfig.BACKEND` |
| Sample guardians | `models/guardian.dart` (`kGuardians`) |
| Add module/reward | `models/content.dart` (`kModules`/`kRewards`) |
| Config/keys/flags | `config/app_config.dart` (+ `--dart-define`) |

## Gotchas (don't undo)
- **iOS has no storyboards** — window is created programmatically with an explicit
  `FlutterEngine` in `ios/Runner/AppDelegate.swift`; don't re-add `UIMainStoryboardFile`.
  iOS deployment target is **15.0** (Google Maps SDK).
- **Maps/backend/video are gated** — default is offline mock (painted map, mock auth).
  They light up only when the matching key/flag is set.
- **JWTs only in `SecureStore`** (never shared_preferences).
- **Android** id `com.americangroupllc.kinnav`; needs JDK 17+; Maps key via
  `manifestPlaceholders[MAPS_API_KEY]`.
- This sandbox can't build Android (Gradle daemon) — builds fine on a normal machine.

## Docs
`requirements/specs/`: REQUIREMENTS (what) · DESIGN (how) · PLAN (when) · PRODUCTION
(go-live + legal gate). Screens: `requirements/design-flow/`. Brand: `assets/logo/`.

## Auth & Backend (Supabase) — updated

Authentication uses the org's real **Supabase** backend.

- `Supabase.initialize(url, anonKey)` runs in `main()` before `runApp` (config in
  `lib/config/app_config.dart`: `supabaseUrl` / `supabaseAnonKey`).
- Sign-in is `SupabaseAuthService.signInWithPassword` in
  `lib/services/auth_service.dart` → `Supabase.instance.client.auth.signInWithPassword`.
- `SignUpScreen` has a "Use test account" button (one-tap QA sign-in).
- Offline/CI (no network): if a Supabase call fails with a socket/network error
  AND the credentials match a provisioned test account, the app falls back to a
  local demo session persisted in `shared_preferences` (`localDemoSession`).
- Sign-out (`AppState.logOut` / `deleteAccount`) clears both the Supabase session
  and the local fallback via `SupabaseAuthService.signOut()`.
- Provisioned test accounts: `qa@safecodeg.com` / `QATest@2026!` (QA, one-tap
  button) and `dev@safecodeg.com` / `DevTest@2026!` (developer). Full detail in
  `docs/DESIGN.md`.
