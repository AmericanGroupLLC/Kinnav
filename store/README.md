# Store submission — Kinnav

Everything needed to put Kinnav on the App Store and Google Play, plus the
screenshots to attach to each listing.

| | Value |
|---|---|
| App name | Kinnav |
| Bundle / application id | `com.americangroupllc.kinnav` |
| Version | `1.0.0+3` (`pubspec.yaml` → `version:`) |
| Apple team | `TLH7Z3G27A` |
| Minimum iOS | 15.0 |
| Android sdk | `compileSdk` / `minSdk` / `targetSdk` follow the Flutter defaults |

## Store listing URLs

Both consoles require these. All three are live routes on the site
(`website/src/App.jsx`), listed in `public/sitemap.xml`:

| Field | URL |
|---|---|
| Support URL | `https://kinnav.com/contact` |
| Privacy policy URL | `https://kinnav.com/privacy` |
| Marketing / website URL | `https://kinnav.com` |
| Terms of service | `https://kinnav.com/terms` |
| Support email | `support@kinnav.com` |

The privacy policy is substantive rather than placeholder — it covers
location, data collected, third parties, retention (call history for 12
months), children, and deletion rights, and both it and the terms name the
support address directly, which reviewers look for.

### These URLs used to be empty to anything but a browser

All four returned HTTP 200, so they looked fine. They were not: the site is a
client-rendered SPA, so every URL served the same 3,818-byte shell with an
**empty `<body>`**. `curl https://kinnav.com/privacy` contained the word
"privacy" zero times.

That matters because Google Play fetches the privacy-policy URL and checks it
for an actual policy. A listing whose policy URL looks blank gets rejected, and
"it works in my browser" is exactly how this one hides.

`website/scripts/prerender.mjs` now bakes `/`, `/privacy`, `/terms`, `/about`
and `/how-it-works` into real HTML at build time (`dist/privacy/index.html`,
…). The `.htaccess` SPA fallback only rewrites when a request matches no real
file or directory, so those directories are served directly and every other
route still falls through to the SPA. The client boots and takes over as
before, so nothing changes in a browser.

`pnpm build` runs it, and `publish-deploy.sh` both runs it and refuses to
publish if `dist/privacy/index.html` or `dist/terms/index.html` is missing or
has no matching text.

> **Not live yet.** The fix is in the source tree; `kinnav.com` still serves the
> old empty shell until someone runs `cd website && pnpm deploy`. Verify with
> `curl -s https://kinnav.com/privacy | grep -c -i privacy` — it must be
> non-zero **before** the URL goes into either console.

## Signing

Android signing is configured and verified. iOS is not, and cannot be from a
machine without an authenticated Xcode.

| | Android | iOS |
|---|---|---|
| Configured | yes | no |
| Key | `~/.android/kinnav-upload.jks`, alias `upload` | distribution cert, team `TLH7Z3G27A` |
| Wired via | `android/key.properties` (gitignored) | Xcode automatic signing |
| Valid until | 2053-12-28 | n/a |

The release variant's certificate fingerprint, from `./gradlew :app:signingReport`:

```
SHA-256: 38:7E:86:13:0F:A6:80:72:8F:2C:0C:3E:92:71:CB:C2:23:76:1F:F4:CC:C8:04:AC:EA:EC:F2:7B:ED:37:3E:35
```

Play Console shows this same fingerprint once the first bundle is uploaded —
if it differs, the wrong key signed the build.

> **Back up the keystore and its password now.** Google Play ties the listing
> to this key. Lose it and you cannot ship an update without going through
> Play's key-reset process. The password lives in `android/key.properties`,
> which is gitignored and therefore not backed up by anything.

The keystore sits in `~/.android/` rather than `~/` only because the
environment it was generated in denied the JVM write access to the home
directory root. Move it anywhere you prefer and update `storeFile` in
`android/key.properties` to match.

## Binaries are deliberately not in this directory

An `.aab` or `.ipa` is tens of megabytes of build output that changes every
release. `build/` is already gitignored for the same reason. Attach them to a
GitHub release or a CI artifact instead of committing them.

### What has actually been verified

- **iOS release compiles.** `flutter build ios --release --no-codesign`
  produces `build/ios/iphoneos/Runner.app` (44 MB) with the right bundle id,
  version `1.0.0 (3)`, display name, and app icons. Release mode is where
  tree-shaking and AOT breakage shows up, so this is worth more than a debug
  build — but the result is unsigned and cannot be uploaded.
- **Android signing is correct.** `:app:signingReport` shows the release
  variant using the upload key (fingerprint above).
- **Android release does not build offline.** It needs Flutter's release
  engine artifacts — `flutter_embedding_release`, `arm64_v8a_release`,
  `armeabi_v7a_release`, `x86_64_release` — from
  `storage.googleapis.com/download.flutter.io`. Only the *debug* engine jars
  are in `~/.gradle/caches`. On a networked machine the first release build
  downloads them and this resolves itself.
- **Release mode cannot run on the iOS Simulator at all** — Flutter rejects
  it outright (`Release mode is not supported for simulators`). Testing a
  release iOS build requires a physical device.
- **The end-to-end suite passes on iOS**, 7/7 on both the iPhone 17 and the
  Pro Max.
- **It cannot capture iOS screenshots.** `binding.takeScreenshot()` returns a
  blank frame there — `convertFlutterSurfaceToImage()` is Android-only — so
  the suite writes seven convincing but empty PNGs and still reports success.
  Check any generated image before trusting it:
  `magick shot.png -format '%k' info:` returns 1 for a blank.
  Capturing from the host with `xcrun simctl io … screenshot` during a
  `--dart-define=HOLD_MS=7000` run does not work either: the app requests
  location on reaching the map, and the system dialog covers the screen for
  the rest of the run. `simctl privacy grant location-always` fixes that, but
  `flutter drive` reinstalls the app on every run and reinstalling resets the
  grant. The suite is still valuable as a test; iOS screenshots have to be
  taken by hand for now.
- **It has not been run on Android.** `integration_test` adds Android build
  dependencies that were not in the local Gradle cache, and the machine it
  was authored on had no network, so `flutter drive -d emulator-5554` failed
  at dependency resolution. Nothing is wrong with the test — run it once on a
  networked machine and Gradle caches what it needs. Verify with a plain
  `flutter build apk --debug` first.

## Android — Google Play

One-time, on the release machine:

```bash
keytool -genkey -v -keystore ~/kinnav-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Then create `android/key.properties` from `android/key.properties.example`
and point `storeFile` at that `.jks`. Both are gitignored — **back the
keystore up somewhere durable. Losing it means you can no longer update the
listing**, short of Play's key-reset process.

```bash
flutter build appbundle --release          # -> build/app/outputs/bundle/release/app-release.aab
```

Verify it is signed with the upload key, not debug, before uploading:

```bash
jarsigner -verify -verbose:summary build/app/outputs/bundle/release/app-release.aab
```

Upload the `.aab` in Play Console → *Production* (or *Internal testing*
first, which is the faster feedback loop).

## iOS — App Store

Signing must be in place first: open `ios/Runner.xcworkspace` in Xcode, sign
in under *Settings → Accounts* with an account on team `TLH7Z3G27A`, and let
automatic signing fetch the distribution profile.

```bash
flutter build ipa --release                # -> build/ios/ipa/*.ipa
```

Upload with Transporter, or:

```bash
xcrun altool --upload-app -f build/ios/ipa/Kinnav.ipa -t ios \
  --apiKey <KEY_ID> --apiIssuer <ISSUER_ID>
```

`flutter build ipa --no-codesign` compiles without signing. It is useful to
prove the release path builds, but the result **cannot be uploaded**.

## Version bumping

Both stores reject a build number they have already seen. Bump
`version: 1.0.0+3` in `pubspec.yaml` before each upload — the part after `+`
is `CFBundleVersion` on iOS and `versionCode` on Android.

## Screenshots

`screenshots/ios` and `screenshots/android` hold captures from the real debug
build running on a simulator and an emulator, already at each store's
required size.

| | Count | Size | Store rule |
|---|---|---|---|
| `ios/` | **1** | 1320 × 2868 | App Store 6.9" iPhone (iPhone 17 Pro Max) |
| `android/` | 5 | 1080 × 2160 | Play caps phone screenshots at 2:1 |

iOS is short: the App Store shows the first three in search results, so at
least three are wanted and this has one. See the note above for why
automation cannot produce them yet.

The Android emulator frame is 1080 × 2400, which is 2.22:1 and would be
rejected. The committed files are cropped to 2:1 by removing the status bar
and gesture bar — OS chrome rather than app content.

### Regenerating them

Both sets come from `integration_test/app_test.dart`, which drives the real
app and screenshots each stop. Nothing is staged by hand, so the images cannot
drift from what the app actually renders.

```bash
# iOS — run against the Pro Max: 1320x2868 is the App Store 6.9" size
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart -d "iPhone 17 Pro Max"

# Android
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart -d emulator-5554
```

Screenshots land in `build/screenshots/`; copy the ones you want into
`store/screenshots/<platform>/`. Android output is 1080x2400 and must be
cropped to 2:1 before upload (see below).

The App Store shows the first 3 in search results; Play requires at least 2
and allows 8.

### Reproducing the Android set by hand

```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
adb shell pm grant com.americangroupllc.kinnav android.permission.ACCESS_FINE_LOCATION
adb shell am start -n com.americangroupllc.kinnav/.MainActivity
adb exec-out screencap -p > shot.png
```

Grant location up front: the permission dialog otherwise steals focus on
first launch and lands in the screenshot. `adb shell screencap -p /sdcard/…`
fails with `Bad address` on this emulator image — use `exec-out`.


## The Android screenshots are NOT safe to upload

Every file in `screenshots/android/` was captured from a debug build and shows
the **"Demo mode (dev) — skip to app"** button, which `kDebugMode` gates and the
release build never renders. A screenshot containing UI the shipped app does not
have is a rejection under Apple 2.3.3 and Play's equivalent metadata policy.

The iOS set had the same problem; `store/screenshots/ios/01-welcome.png` was
deleted for that reason and replaced with `01-sign-in.png`, captured with the
fix below.

**How to capture clean ones.** `AppConfig.showDevShortcuts` is
`kDebugMode && !SCREENSHOT`, so building with `--dart-define=SCREENSHOT=true`
renders exactly what release renders. iOS release builds cannot run on a
simulator at all, so this flag is the only honest way to get simulator shots.

```bash
flutter run -d <device> --dart-define=SCREENSHOT=true
# then, against a freshly erased simulator so onboarding is not skipped:
xcrun simctl erase <udid> && xcrun simctl boot <udid>
xcrun simctl install <udid> build/ios/Debug-iphonesimulator/Runner.app
xcrun simctl launch  <udid> com.americangroupllc.kinnav
xcrun simctl io <udid> screenshot shot.png
```

Verify before uploading — the footer of a clean shot is a single flat colour:

```bash
magick shot.png -crop 1320x300+0+2568 +repage -format '%k' info:   # 1 = clean
```

## Before you submit

- [ ] Bump `version:` in `pubspec.yaml`
- [ ] `flutter analyze` and `flutter test` clean
- [ ] Release build on a real device, not just a simulator — the debug build
      is the only thing verified in these screenshots
- [ ] Privacy policy and terms reachable: the app links to `kinnav.com`, and
      both stores require a working privacy-policy URL
- [ ] Apple privacy nutrition labels — the app collects location and, through
      Supabase, account data
- [ ] Android data-safety form, same information
- [ ] Location justification: both stores ask why a safety app needs
      background/precise location

## Known gaps

- The About screen no longer lists Instagram, Facebook or Twitter. They
  advertised `@getsaferapp` — the previous brand — and pointed at bare
  `instagram.com` / `facebook.com` roots. Reviewers follow outbound links.
  Restore them with real profile URLs once the accounts exist.
- **The guardians shown in the screenshots are sample data.** Both stores
  require screenshots to reflect real functionality, and Safe Call still says
  `DEMO · simulated safe call` on screen. Treat `screenshots/` as internal
  until a backend is wired; shipping them as-is claims a live responder
  network the build does not have.
- Safety contacts now start **empty**. The app used to seed two fictional
  contacts ("Mom", "Emma") with invented numbers, and starting a Safe Call
  texts every safety contact the user's precise live location — so a user who
  never edited the list would have sent their location to numbers they had
  never seen. The screenshots predate this change and may still show the
  seeded pair; retake them before they go on a listing.

## Claims the binary has to be able to back up

App Review reads the listing and then tries the app. Three defects were fixed
because the app asserted things that were not true, which is both a safety
problem and a 2.3.1 rejection risk:

- Choosing **Emergency** showed "Police added" without ever dialling. It now
  places a real confirmed 911 call.
- Cancelling the "Add police" confirmation still flipped the badge to "Police
  added" and wrote `policeAdded: true` into call history.
- **Log out left everything behind** — profile, safety contacts, Safe Call
  history, rewards and plan. The next person to sign in on the same device
  skipped profile setup, saw the previous user's name, and could read their
  call history.

Covered by `test/emergency_test.dart` and the `logOut` group in
`test/app_state_test.dart`. Keep them passing: each one is a claim a reviewer
can check by hand in about a minute.

## Privacy policy — what a reviewer sees

The listing's policy URL is `https://kinnav.com/privacy`, and that page is the
binding document. The app's own Legal Terms and Privacy Policy screens are
plain-language summaries that link out to the published pages, so the two
cannot drift apart — a reviewer comparing them sees the same source of truth.
Both name `support@kinnav.com` directly.

Every place the app invites contact goes to that one address, from
`AppConfig.supportEmail`: the drawer's Contact Us, About, the legal screens,
and Feedback.

## Privacy forms — drafted from what the app declares

Both consoles ask these before review. Answers below follow the permissions
actually declared and the code that uses them; check each against the build
you submit, because a form that contradicts the binary is a rejection.

Declared permissions:

| Platform | Permission | Why |
|---|---|---|
| iOS | `NSLocationWhenInUseUsageDescription` | show the user and nearby guardians on the map |
| iOS | `NSLocationAlwaysAndWhenInUseUsageDescription` | keep sharing live location during a Safe Call |
| iOS | `NSCameraUsageDescription` | video Safe Call |
| Android | `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` | same as iOS |
| Android | `INTERNET` | auth and, once wired, the guardian network |

### Apple — App Privacy

| Data type | Collected | Linked to user | Tracking | Purpose |
|---|---|---|---|---|
| Precise location | yes | yes | no | App Functionality |
| Email address | yes (Supabase sign-in) | yes | no | App Functionality |
| Name | yes (profile) | yes | no | App Functionality |
| User content (feedback) | yes, by email | yes | no | App Functionality |
| Identifiers | Supabase user id | yes | no | App Functionality |

No third-party advertising or analytics SDK ships today — `analytics` is a
no-op boundary. **Revisit this the moment Firebase or Sentry is added.**

### Google Play — Data safety

- Collected: location (precise), personal info (name, email), user id.
- Shared with third parties: **no** — Supabase is a processor, not a
  recipient, but declare it if that changes.
- Encrypted in transit: yes (HTTPS/Supabase).
- Deletion: users can request deletion in-app or by email; the privacy policy
  says so at `https://kinnav.com/privacy`.
- Data collection is required, not optional — the app cannot find guardians
  without location.

### Questions both stores will ask about a safety app

- **Why background/always location?** Only to keep sharing live location for
  the duration of a Safe Call. If that is not implemented in the build you
  submit, drop `NSLocationAlwaysAndWhenInUseUsageDescription` — asking for
  more than you use draws scrutiny.
- **Is this a medical or emergency service?** No. The Terms say Kinnav is not
  a replacement for emergency services and the app tells users to call 911.
  Say the same in review notes.
- **Account for review.** Reviewers need working credentials. Supabase test
  accounts exist in `lib/services/auth_service.dart`; supply one, or the
  reviewer will bounce the build.

## Safe Call — how the token flow is meant to work

The app never holds the Agora App Certificate and never calls Agora's REST
API. It asks the Kinnav backend, which signs a credential scoped to one
channel:

```
Kinnav app  --POST /calls/token-->  Kinnav API  --App ID + Certificate-->  Agora
            <---- short-lived token ----                <---- token ----
            ---- joins channel ---->  Agora
```

`lib/services/call_token_client.dart` implements the app's half and is
covered by eight tests, including the failure paths that matter on a safety
app: a malformed 200, a missing token, and a hung server (which fails fast
rather than leaving someone waiting).

The backend contract it assumes:

| | |
|---|---|
| Request | `POST {API_BASE_URL}/calls/token` `{"channel": "...", "role": "publisher"}` |
| Auth | `Authorization: Bearer <supabase access token>` |
| Response | `{"appId","channel","token","uid","expiresAt"}` |
| `expiresAt` | Unix seconds or ISO-8601; both are parsed |

`snake_case` keys are read too, so a Python or Go service needs no
special-casing. If the real endpoint differs, `CallToken.fromJson` and the
`path` argument are the only things to change.

**What is still missing:** an RTC package (none is in `pubspec.yaml`) and a
`CallService` that joins the channel with the token. Until then
`MockCallService` is what ships and the Safe Call screen discloses that it
connects nobody.
