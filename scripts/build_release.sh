#!/usr/bin/env bash
# Build Kinnav release artifacts locally.
#   ./scripts/build_release.sh android   -> APK + AAB (needs android/key.properties)
#   ./scripts/build_release.sh ios       -> signed IPA (needs Apple signing + ExportOptions.plist)
#   ./scripts/build_release.sh all
# Pass secrets via env: MAPS_API_KEY, AGORA_APP_ID (optional).
set -euo pipefail
cd "$(dirname "$0")/.."

DEFINES=(--dart-define=BACKEND=americangroupllc --dart-define=FLAVOR=prod)
[ -n "${MAPS_API_KEY:-}" ] && DEFINES+=(--dart-define=MAPS_API_KEY="$MAPS_API_KEY")
[ -n "${AGORA_APP_ID:-}" ] && DEFINES+=(--dart-define=AGORA_APP_ID="$AGORA_APP_ID")

target="${1:-all}"
flutter pub get

build_android() {
  echo "▶ Android release (APK + AAB)"
  flutter build apk --release "${DEFINES[@]}"
  flutter build appbundle --release "${DEFINES[@]}"
  echo "APK: build/app/outputs/flutter-apk/app-release.apk"
  echo "AAB: build/app/outputs/bundle/release/app-release.aab"
}
build_ios() {
  echo "▶ iOS release (IPA)"
  flutter build ipa --release "${DEFINES[@]}" \
    --export-options-plist=ios/ExportOptions.plist
  echo "IPA: build/ios/ipa/*.ipa"
}

case "$target" in
  android) build_android ;;
  ios) build_ios ;;
  all) build_android; build_ios ;;
  *) echo "usage: $0 [android|ios|all]"; exit 1 ;;
esac
