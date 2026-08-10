# Kinnav — Architecture & Design

_All-in-one women's safety, empowerment and rewards app (Flutter, iOS + Android)._

This document describes the **actual current code** under `lib/`. It complements
the deeper product material in `requirements/specs/` and the compact orientation
map in `AGENTS.md`.

---

## 1. Overview

Kinnav is a single Flutter application built with Material 3. It combines:

- **Safety** — a home map of nearby guardians, "Safe Call" flow, safety
  contacts, and one-tap emergency dialing.
- **Empowerment** — a guardian training course and learning modules.
- **Rewards** — redeemable rewards and a subscription tier.

The app runs fully on-device with local persistence, and authenticates users
against the org's **Supabase** backend. It degrades gracefully offline (see
§7 Auth & Backend).

---

## 2. Architecture (text diagram)

```
                        ┌───────────────────────────┐
                        │          main()           │
                        │  WidgetsFlutterBinding     │
                        │  Storage.init()            │
                        │  Supabase.initialize(...)  │
                        │  AppState(storage)         │
                        │  runApp(KinnavApp)          │
                        └────────────┬──────────────┘
                                     │
                        ┌────────────▼──────────────┐
                        │   MaterialApp (AppTheme)   │
                        │        RootRouter          │  ← ListenableBuilder(appState)
                        └────────────┬──────────────┘
                                     │  picks entry screen by session flags
        ┌───────────────┬───────────┴───────────┬──────────────────┐
        ▼               ▼                       ▼                  ▼
  OnboardingScreen  SignUpScreen        ProfileSetupScreen     HomeMapScreen
                        │                                         │
                        ▼                                         ▼
            SupabaseAuthService                        Menu drawer → feature screens
        (Supabase auth + offline fallback)     (guardians, modules, rewards, calls…)

   ┌──────────────────────────── Services / State layer ───────────────────────────┐
   │  AppState (ChangeNotifier)  ── single source of truth for session + user data  │
   │  Storage (shared_preferences wrapper)  ── typed local persistence              │
   │  SupabaseAuthService  ── real auth + offline test-account fallback             │
   │  Services (locator)   ── GuardianService / CallService / LocationService /     │
   │                          PurchaseService / NotificationService                 │
   │  SecureStore (flutter_secure_storage)  ── legacy token store (Keychain)        │
   └────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. State management

- **`AppState` (`lib/app_state.dart`)** is a `ChangeNotifier` and the single
  source of truth for session + user data: `onboarded`, `signedIn`, `profile`,
  safety contacts, redeemed rewards, completed modules, subscription plan, call
  history, and guardian-course progress.
- A global `late AppState appState` is created in `main()` (simple accessor;
  a DI/provider setup can replace it later).
- The UI reacts via `ListenableBuilder(listenable: appState, …)` — most notably
  in `RootRouter`, which re-selects the entry screen whenever state changes.
- All mutations persist through `Storage` before calling `notifyListeners()`.

---

## 4. File map

| Path | Responsibility |
|------|----------------|
| `lib/main.dart` | Entry point: binding, error boundary, `Storage.init()`, `Supabase.initialize()`, `AppState` creation, `RootRouter`. |
| `lib/app_state.dart` | `AppState` (`ChangeNotifier`) — session + user data, persistence, sign-in/out. |
| `lib/config/app_config.dart` | Build-time config via `--dart-define` (Supabase URL/key, maps/agora keys, backend flag, emergency number). |
| `lib/theme/app_theme.dart` | `AppColors` brand palette + `AppTheme.light` (Material 3). |
| `lib/services/auth_service.dart` | `SupabaseAuthService` — real Supabase auth + offline test-account fallback. |
| `lib/services/storage.dart` | `Storage` — typed wrapper over `shared_preferences`. |
| `lib/services/secure_store.dart` | `SecureStore` — Keychain/Keystore token store (legacy gateway tokens). |
| `lib/services/services.dart` | Service locator for guardian/call/location/purchase/notification services. |
| `lib/services/auth_api.dart` | Legacy API-gateway auth client (retained; not on the active sign-in path). |
| `lib/services/*` | `location_service`, `call_service`, `guardian_service`, `purchase_service`, `notification_service`, `analytics_service`, `emergency`, `links`, `api_client`. |
| `lib/models/*` | `user_profile`, `safety_contact`, `guardian`, `call_record`, `call_type`, `content`. |
| `lib/screens/*` | 21 screens: onboarding, sign-up, profile setup, home map, guardians, modules, rewards, calls, chat, profile, legal, feedback, etc. |
| `lib/widgets/*` | Reusable UI: `avatar`, `primary_button`, `coach_bubble`, `map_view`, `live_map`. |

---

## 5. Navigation flow

`RootRouter` (`lib/main.dart`) chooses the entry screen from `AppState` flags,
reacting to changes:

```
!onboarded            → OnboardingScreen
onboarded & !signedIn → SignUpScreen        (Supabase sign-in / "Use test account")
signedIn & !hasProfile→ ProfileSetupScreen
otherwise             → HomeMapScreen        (main app; MenuDrawer → feature screens)
```

From `HomeMapScreen`, the `MenuDrawer` and in-screen actions reach the feature
screens (guardians, guardian course, modules + module detail, rewards,
subscription, safe call / call options / call history, chat, safety contacts,
profile, about, legal, feedback, how-to-use). Screen-to-screen navigation uses
`Navigator.push` with `MaterialPageRoute`.

---

## 6. Data & persistence

- **Local:** `Storage` wraps `shared_preferences` for typed, namespaced
  persistence (bools, strings, JSON objects, JSON lists, string sets). `AppState`
  serializes its models (e.g. `UserProfile`, `SafetyContact`, `CallRecord`) to
  JSON through it. Keys are centralized as constants in `AppState`.
- **Secure:** `SecureStore` uses `flutter_secure_storage` (iOS Keychain /
  Android Keystore) for tokens. Supabase's own session persistence is managed by
  `supabase_flutter`.
- **Offline session flag:** `SupabaseAuthService` records an offline fallback
  session under the `localDemoSession` key in `shared_preferences`.

---

## 7. Auth & Backend (Supabase)

Authentication runs against the org's **Supabase** project.

- **Initialization** — `main()` calls
  `Supabase.initialize(url: AppConfig.supabaseUrl, anonKey: AppConfig.supabaseAnonKey)`
  before `runApp`. Config lives in `lib/config/app_config.dart`:
  - URL: `https://smvvjivvlprjhzhoizym.supabase.co`
  - anon/publishable key: `sb_publishable_nqtYGp48NKiRF53zivkpsQ_bRiqDSfc`
  - Both are overridable via `--dart-define=SUPABASE_URL=… / SUPABASE_ANON_KEY=…`.
- **Sign-in** — `SupabaseAuthService.signInWithPassword(email, password)`
  (`lib/services/auth_service.dart`) calls
  `Supabase.instance.client.auth.signInWithPassword(email:, password:)`. On
  success `AppState.signIn()` flips the session flag and `RootRouter` advances
  to profile setup / home. The `SignUpScreen` primary "Log in" button uses this.
- **One-tap test account** — the "Use test account" button pre-fills and signs
  in with the QA credentials below.
- **Offline fallback** — this build/CI environment (and offline demos) have no
  network, so the live Supabase call fails with a socket/network error. In that
  case **only**, and **only** when the entered credentials exactly match one of
  the provisioned test accounts, the service persists a local demo session
  (`shared_preferences` key `localDemoSession`) so the app stays runnable
  offline. On a networked device the real Supabase path is always used. A code
  comment in `auth_service.dart` documents this.
- **Sign-out** — `AppState.logOut()` calls `SupabaseAuthService.signOut()`,
  which clears **both** the Supabase session and the local fallback flag (then
  `SecureStore` is cleared for any legacy tokens). `deleteAccount()` does the
  same and wipes all local storage.

### Provisioned test/demo accounts

These are intentional shared test credentials for QA/dev against the demo
backend (not real end-user accounts):

| Role | Email | Password |
|------|-------|----------|
| QA (one-tap test button) | `qa@safecodeg.com` | `QATest@2026!` |
| Developer | `dev@safecodeg.com` | `DevTest@2026!` |

---

## 8. Theme

- **`AppColors`** — brand purple/lavender palette: `primary` `#9B59D0`,
  `primaryDark` `#6A1B9A`, `primaryLight` `#B57BE0`, lavender backgrounds,
  neutral text colors, and semantic colors (`danger`, `online`, `pin`), plus a
  `primaryGradient`.
- **`AppTheme.light`** — Material 3 (`useMaterial3: true`) with a lavender
  scaffold background, transparent flat app bars, tinted dividers, and text
  themed to the brand colors. The app runs light-theme only today.

---

## 9. Platform notes

- **Dependencies** (`pubspec.yaml`): `supabase_flutter`, `shared_preferences`,
  `flutter_secure_storage`, `url_launcher`, `geolocator`,
  `google_maps_flutter`, `http`, `cupertino_icons`.
- **iOS** — Podfile platform is iOS 15.0. The Runner uses a programmatic
  `SceneDelegate`/`AppDelegate` (no `Main` storyboard); `UIMainStoryboardFile`
  is intentionally **omitted** from `Info.plist`. Simulator debug build:
  `flutter build ios --simulator --debug`.
- **Android** — standard Flutter Android host under `android/app/src/main/`.
- **Config** — feature flags and secrets are supplied at build time via
  `--dart-define` (see `AppConfig`); defaults keep the app runnable in a
  sandbox/offline environment.
