# Safer — Production / Field-Pilot Runbook

This is the exact, ordered checklist to take Safer from the current
**field-pilot-ready build** to a live pilot (TestFlight + Play internal testing)
and then production. Items you must supply are marked **[YOU]** (accounts, keys,
legal). Everything in the app is already wired to accept them.

> ⚠️ **Life-safety product.** Do not run a public launch without the legal &
> safety gate in §9 completed. A field pilot must use a small, **vetted** guardian
> group and clearly disclose that Safer is **not a replacement for 911**.

---

## 0. Current state

- ✅ Full Flutter app (iOS + Android), onboarding → auth → profile → home.
- ✅ Real GPS (`geolocator`), live-location UI, permissions configured.
- ✅ Google Maps integrated & **gated** — painted fallback until a key is added.
- ✅ Safe Call flow + persisted history; guardian 40h course + dashboard.
- ✅ Persistence, subscription UI, legal/privacy screens, CI, tests.
- ⛔ Backend, real-time video, push, payments, legal = the steps below.

## 1. Prerequisites **[YOU]**

| Need | Where |
|---|---|
| Apple Developer account ($99/yr) | developer.apple.com |
| Google Play Console ($25 one-time) | play.google.com/console |
| Firebase project | console.firebase.google.com |
| Google Maps API key (iOS + Android, Maps SDK) | console.cloud.google.com |
| Agora project (App ID + token server) | console.agora.io |

## 2. Build-time config (already implemented)

All keys flow through `lib/config/app_config.dart` via `--dart-define`:

```bash
flutter run \
  --dart-define=FLAVOR=prod \
  --dart-define=BACKEND=firebase \
  --dart-define=MAPS_API_KEY=YOUR_KEY \
  --dart-define=AGORA_APP_ID=YOUR_APP_ID \
  --dart-define=EMERGENCY_NUMBER=911
```
Tip: use `--dart-define-from-file=config/prod.json` to avoid long commands.

## 3. Google Maps  (turns on the live map)

1. **iOS**: set the key in `ios/Runner/Info.plist` → `GMSApiKey` (AppDelegate reads it).
2. **Android**: `export MAPS_API_KEY=YOUR_KEY` before building (wired via
   `manifestPlaceholders` in `android/app/build.gradle.kts`), or hardcode in the manifest.
3. Pass `--dart-define=MAPS_API_KEY=YOUR_KEY` so `LiveMap` shows `GoogleMap`
   instead of the painted fallback.

## 4. Firebase backend + Auth  **[YOU + code]**

1. Install tooling: `dart pub global activate flutterfire_cli`.
2. `flutterfire configure` — generates `lib/firebase_options.dart` and adds
   `google-services.json` (Android) + `GoogleService-Info.plist` (iOS).
3. Add deps: `flutter pub add firebase_core firebase_auth cloud_firestore firebase_messaging`.
4. In `main.dart`, before `runApp`: `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);` (guard on `AppConfig.hasBackend`).
5. Implement `FirebaseAuthService` / `FirestoreGuardianService` (interfaces already
   exist in `lib/services/`), then switch them on in `lib/services/services.dart`
   (the TODO lines). No UI changes needed.
6. Firestore collections: `users`, `guardians` (with geohash for proximity),
   `calls`, `safety_contacts`. Add security rules (auth-scoped).

## 5. Real-time Safe Call — Agora  **[YOU + code]**

1. `flutter pub add agora_rtc_engine`.
2. Stand up a **token server** (Agora tokens must be minted server-side; never
   ship the App Certificate in the app) — a Firebase Cloud Function works.
3. Implement `AgoraCallService` against the existing `CallService` interface
   (connect → join channel; addPolice → dial via `Emergency`; end → leave), then
   enable it in `services.dart`.
4. iOS: add mic/camera usage strings to `Info.plist`
   (`NSCameraUsageDescription`, `NSMicrophoneUsageDescription`).

## 6. Push notifications  **[YOU + code]**

1. iOS: enable Push in the Apple Developer portal; upload APNs key to Firebase.
2. `firebase_messaging` + a `FcmNotificationService` implementing
   `NotificationService`; store device tokens on the user/guardian docs.
3. Cloud Function: on a new Safe Call, push to matched nearby guardians and to
   the caller's safety contacts (with live-location link).

## 7. Payments / subscription  **[YOU + code]**

1. Create products in App Store Connect & Play Console: `safer_monthly` ($3.99),
   `safer_annual` ($39.99).
2. `flutter pub add in_app_purchase`; implement `StoreKitPurchaseService`
   against the existing `PurchaseService` interface; enable in `services.dart`.

## 8. Build, sign & distribute (field pilot)

- **Restore the launch storyboard** on a normal machine (this sandbox couldn't
  run `ibtool`). Run `flutter create . --platforms ios,android` to regenerate
  `LaunchScreen.storyboard`, or add a proper launch screen; re-add it to the
  Xcode target. (App icons/splash: `flutter_launcher_icons` + `flutter_native_splash`.)
- **iOS**: set Team & signing in Xcode → Archive → upload to **TestFlight**.
  `flutter build ipa --dart-define=...`.
- **Android**: create an upload keystore, set `signingConfig` in
  `android/app/build.gradle.kts` (replace the debug placeholder) →
  `flutter build appbundle --dart-define=...` → **Play Console → Internal testing**.
- Invite your vetted guardian + user pilot group by email.

### 8.1 Release artifacts (APK / AAB / IPA) — now wired

The repo produces release artifacts two ways:

**A. CI → GitHub Releases (recommended, "attached to the repo").**
`.github/workflows/release.yml` runs on a version tag and uploads the APK, AAB and
IPA to a GitHub Release:
```
git tag v1.0.0 && git push origin v1.0.0
```
Required repo **secrets** (Settings → Secrets → Actions):
`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEY_PROPERTIES`, `MAPS_API_KEY`, and the Apple
signing set (cert `.p12` + provisioning profile + `MATCH`/App Store Connect key).

**B. Local builds** via `scripts/build_release.sh [android|ios|all]`:
- Android needs `android/key.properties` (see `key.properties.example`) →
  `app-release.apk` + `app-release.aab` (signed, minified with ProGuard).
- iOS needs Apple signing + `ios/ExportOptions.plist` (set your `teamID`) →
  `build/ios/ipa/*.ipa`.

> ⚠️ Signed binaries require an Apple Developer cert/profile and an Android upload
> keystore — they cannot be produced without those credentials. A `--no-codesign`
> iOS build compiles (verified) but is **not** installable/releasable.

## 9. Legal & safety launch gate  **[YOU — required]**

- [ ] Lawyer-reviewed **Terms of Service** & **Privacy Policy** (replace the
      placeholder text in `lib/screens/legal_screen.dart`).
- [ ] **Guardian vetting**: identity + background checks, references, the 40-hour
      course completion, and an offboarding/report process.
- [ ] **Incident & escalation protocol**; clear "call 911" messaging in-app.
- [ ] Liability **insurance** and a safety advisory review.
- [ ] Data protection: GDPR/CCPA compliance, data-retention policy, encryption
      review (move tokens to `flutter_secure_storage`).
- [ ] Emergency-services relationship/disclaimer reviewed for each pilot region.

## 10. Post-pilot → production

- Monitoring (Crashlytics/Sentry via the existing `AnalyticsService`), analytics,
  on-call ops for Safe Calls, guardian payout pipeline, scaled geo-matching,
  load testing, accessibility & localization audits, then public store release.
