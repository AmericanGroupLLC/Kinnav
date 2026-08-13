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

## Binaries are deliberately not in this directory

Store-uploadable binaries are **not committed**, for two reasons.

They cannot currently be produced. Google Play refuses a bundle signed with
debug keys, and `android/app/build.gradle.kts` falls back to the debug
signing config whenever `android/key.properties` is absent — which it is, and
should stay that way, since a keystore must never be committed. iOS uses
`CODE_SIGN_STYLE = Automatic`, which needs Xcode signed into the Apple
Developer account and network access to fetch a distribution profile.

They also do not belong in git. An `.aab` or `.ipa` is tens of megabytes of
build output that changes every release; `build/` is already gitignored for
the same reason. Attach them to a GitHub release or a CI artifact instead.

Build them with the steps below when you are ready to submit.

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

### What is covered, and what is missing

Android has five screens: welcome, guardian map, *Reach a Guardian*, the
menu, and About. iOS has **only the welcome screen**.

That gap is not an oversight. The captures were automated, and Android can be
driven with `adb shell input tap`, while the iOS Simulator has no equivalent —
`simctl` cannot synthesise touches, and the AppleScript route was unavailable
in that environment. The remaining iOS screenshots have to be taken by tapping
through the app by hand:

```bash
xcrun simctl boot "iPhone 17 Pro Max"
flutter run -d "iPhone 17 Pro Max"
# tap "Demo mode (dev) — skip to app", navigate, then per screen:
xcrun simctl io booted screenshot store/screenshots/ios/0N-name.png
```

The App Store wants up to 10 and shows the first 3 in search results; Play
requires at least 2 and allows 8. Aim to match the Android set so the two
listings tell the same story.

### Reproducing the Android set

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
- Legal copy in `lib/screens/legal_screen.dart` is explicitly marked
  placeholder pending legal review.
