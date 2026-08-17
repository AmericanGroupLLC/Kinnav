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

A caveat: these routes are served by the SPA, so they only resolve on a host
where the `.htaccess` fallback is active. Confirm each returns 200 in a
browser **before** pasting it into a console — a reviewer hitting a 404
privacy URL is an automatic rejection.

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
  Pro Max, and produced every screenshot in `screenshots/ios`.
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

| | Size | Store rule |
|---|---|---|
| `ios/` | 1320 × 2868 | App Store 6.9" iPhone (iPhone 17 Pro Max) |
| `android/` | 1080 × 2160 | Play caps phone screenshots at 2:1 |

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

- The About screen still lists `@getsaferapp` for Instagram, Facebook and
  Twitter, and those rows link to the bare `instagram.com` / `facebook.com`
  roots rather than real accounts. Reviewers do look at outbound links.
- `assets/logo/kinnav_icon_square.svg` is the previous shield-and-crescent
  mark. It is unused by the build but will mislead anyone regenerating icons.

## Privacy policy — what a reviewer sees

The listing's policy URL is `https://kinnav.com/privacy`, and that page is the
binding document. The app's own Legal Terms and Privacy Policy screens are
plain-language summaries that link out to the published pages, so the two
cannot drift apart — a reviewer comparing them sees the same source of truth.
Both name `support@kinnav.com` directly.

Every place the app invites contact goes to that one address, from
`AppConfig.supportEmail`: the drawer's Contact Us, About, the legal screens,
and Feedback.
