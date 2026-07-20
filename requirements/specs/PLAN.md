# Safer — Implementation Plan

Maps requirements (`REQUIREMENTS.md`) to phases. Legend: ✅ done · 🟡 in progress · ⬜ todo · 🔒 gated on external setup (account/API key/legal).

## Progress summary (client-complete, backend-ready)

All phases have been implemented to the fullest extent possible **inside this
build environment**. Every phase now has a complete, swap-ready client
architecture; items marked 🔒 require external accounts/keys/legal sign-off that
cannot be provisioned here and are wired behind interfaces ready to accept them.

- **Phase 2** ✅ real GPS (`geolocator`) + permissions + live-location UI · 🔒 Google Maps SDK (API key) — painted map fallback in place.
- **Phase 3** ✅ service/repository boundary + persisted data (profile, contacts, history, progress) · 🔒 Firebase/REST backend.
- **Phase 4** ✅ Safe Call flow + persisted call history via `CallService` · 🔒 real WebRTC/Agora/Twilio.
- **Phase 5** ✅ guardian 40h course + verification + dashboard/availability + `NotificationService` · 🔒 FCM/APNs push, payouts.
- **Phase 6** ✅ `PurchaseService` + restore + subscription state · 🔒 real `in_app_purchase` store products.
- **Phase 7** ✅ Legal/Privacy screens, accessibility labels, tests, CI · 🔒 i18n translation, independent legal/safety review, store assets.


## Phase 0 — Prototype (DONE)
- ✅ All screens, navigation/IA, brand theme, offline map, Safe Call simulation, coach marks.

## Phase 1 — App Foundation (client, backend-ready) — **THIS ITERATION**
Goal: real app skeleton — session, persistence, onboarding, and a service layer with
mock implementations that a real backend can drop into later.
- 🟡 State management: `AppState` (ChangeNotifier) as single source of truth.
- 🟡 Local persistence via `shared_preferences` (profile, session, onboarding seen, safety contacts, redeemed rewards, module progress, subscription).
- 🟡 Service layer interfaces + mock impls: `AuthService`, `GuardianService`, `CallService`, `LocationService` (swap-in point for backend/WebRTC/maps).
- 🟡 Onboarding flow: Splash → How-to-Use (first run) → Sign up (**18+ age gate**) → Profile setup → Home.
- 🟡 Log out / delete account wired to session.
- 🟡 Emergency dial + Invite-a-Friend + social/legal links via `url_launcher`.
- 🟡 Safety Contacts, Rewards redemption, Feedback, Profile → persisted.
- 🟡 Module detail screens with lesson content + completion tracking.
- 🟡 Subscription screen ($3.99/mo, $39.99/yr) — UI + local state (no real IAP yet).
- 🟡 Verify build + run on iOS simulator.

## Phase 2 — Location & Maps
- ⬜ `geolocator` for GPS (foreground); permissions (iOS `Info.plist`, Android manifest).
- ⬜ Real map SDK (`google_maps_flutter` or `apple_maps_flutter`) behind `LocationService`/a `MapProvider` abstraction; keep painted map as offline fallback.
- ⬜ Background location + geofencing for guardian proximity.

## Phase 3 — Backend & Auth
- ⬜ Backend (Firebase or custom): Auth (phone/email OTP), Firestore/DB for users, guardians, calls, content, rewards.
- ⬜ Replace mock services with real API clients.
- ⬜ Guardian presence + real-time nearby geo-queries.

## Phase 4 — Real-time Safe Call
- ⬜ Multi-party voice/video (Agora/Twilio/WebRTC) behind `CallService`.
- ⬜ Guardian ring/answer flow; add-police escalation; call recording/consent policy.
- ⬜ Notify safety contacts with live location on call start.

## Phase 5 — Notifications & Guardian Ops
- ⬜ Push (FCM/APNs): alert guardians off-app, alert safety contacts.
- ⬜ Guardian onboarding: 40-hour course enrollment + verification workflow.
- ⬜ Guardian earnings/payouts.

## Phase 6 — Monetization
- ⬜ In-app purchases / subscriptions (`in_app_purchase`).
- ⬜ Reward-partner integrations; referral tracking.

## Phase 7 — Security, Compliance, Quality
- ⬜ Encryption, PII minimization, GDPR/CCPA, real Legal Terms & Privacy Policy.
- ⬜ Accessibility pass; i18n/l10n.
- ⬜ Test suite (unit/widget/integration), CI/CD, crash reporting, analytics.
- ⬜ App icons, splash, store listings; **independent safety/legal review** (life-safety product).

## Architecture (target)

```
lib/
├── main.dart
├── app_state.dart            # ChangeNotifier: session, profile, contacts, rewards…
├── services/                 # interfaces + mock impls (backend swap-in point)
│   ├── auth_service.dart
│   ├── guardian_service.dart
│   ├── call_service.dart
│   ├── location_service.dart
│   └── storage.dart          # shared_preferences wrapper
├── models/                   # Guardian, Module, Reward, CallType, UserProfile…
├── theme/  ├── widgets/  └── screens/
```
