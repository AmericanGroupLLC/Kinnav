#!/usr/bin/env bash
#
# Answers "can this go to the stores?" with evidence instead of opinion.
#
#   bash scripts/preflight.sh
#
# Exits non-zero if anything would fail review or ship a demo as a product.
# Run it before every submission; it is quicker than a rejection.

set -uo pipefail
cd "$(dirname "$0")/.."

pass=0; fail=0; warn=0
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; pass=$((pass+1)); }
no()   { printf '  \033[31m✗\033[0m %s\n' "$1"; fail=$((fail+1)); }
meh()  { printf '  \033[33m!\033[0m %s\n' "$1"; warn=$((warn+1)); }
head_() { printf '\n\033[1m%s\033[0m\n' "$1"; }

head_ "Code health"
# Distinguish "the toolchain is missing" from "the code is broken" — reporting
# a missing flutter as a code failure sends you hunting for the wrong thing.
if ! command -v flutter >/dev/null 2>&1; then
  meh "flutter is not on PATH — skipping analyze and tests"
else
  if flutter analyze >/dev/null 2>&1; then ok "flutter analyze clean"; else no "flutter analyze reports issues"; fi
  if flutter test >/dev/null 2>&1; then ok "widget tests pass"; else no "widget tests fail"; fi
fi

head_ "Ships as a product, not a demo"
# The single most important check: the core feature must actually connect.
# Test the cause, not the banner — the banner is now driven by
# CallService.isSimulated, so it disappears on its own once this is fixed.
if ! grep -qE "^  (agora_rtc_engine|flutter_webrtc|livekit_client):" pubspec.yaml; then
  no "Safe Call connects nobody — no RTC package in pubspec; CallService has only MockCallService"
elif ! grep -rq "class .*CallService" lib/services/ --include="*.dart" \
     || ! grep -rqE "isSimulated => false" lib/services/; then
  no "an RTC package is present but no real CallService implements it"
else
  ok "a real CallService is wired"
fi
if grep -q "defaultValue: 'mock'" lib/config/app_config.dart; then
  meh "BACKEND defaults to mock — pass --dart-define=BACKEND=… for a real build"
else
  ok "BACKEND does not default to mock"
fi
for k in MAPS_API_KEY AGORA_APP_ID; do
  if grep -q "String.fromEnvironment('$k', defaultValue: '')" lib/config/app_config.dart; then
    meh "$k is empty by default — supply it via --dart-define at build time"
  fi
done
if grep -rq "class MockPurchaseService" lib/ && ! grep -rq "in_app_purchase" pubspec.yaml; then
  meh "purchases are mocked; paid tiers will not charge anyone"
fi

head_ "Store metadata"
grep -q "support@kinnav.com" lib/config/app_config.dart \
  && ok "support address is support@kinnav.com" \
  || no "AppConfig.supportEmail is not the published address"
grep -rqi "gmail" lib/ && no "a gmail address is still published in lib/" || ok "no personal address in lib/"
for u in privacy terms contact; do
  grep -rq "kinnav.com/$u" store/README.md && ok "listing URL recorded: kinnav.com/$u" || meh "no listing URL recorded for /$u"
done

head_ "Screenshots"
for p in ios android; do
  d="store/screenshots/$p"; n=$(ls "$d"/*.png 2>/dev/null | wc -l | tr -d ' ')
  [ "$n" -ge 3 ] && ok "$p: $n screenshots" || meh "$p: only $n — the App Store shows the first 3"
  # A blank capture has a single colour. takeScreenshot() produces these on iOS.
  for f in "$d"/*.png; do
    [ -e "$f" ] || continue
    if command -v magick >/dev/null 2>&1 && [ "$(magick "$f" -format '%k' info: 2>/dev/null)" = "1" ]; then
      no "blank screenshot: $f"
    fi
  done
done

head_ "Signing"
[ -f android/key.properties ] && ok "android/key.properties present" \
  || meh "android/key.properties missing — release will fall back to debug keys, which Play rejects"
git ls-files --error-unmatch android/key.properties >/dev/null 2>&1 \
  && no "android/key.properties is TRACKED IN GIT — rotate the key" \
  || ok "signing config is not committed"

head_ "Version"
v=$(grep '^version:' pubspec.yaml | awk '{print $2}')
ok "version $v (both stores reject a build number they have seen before)"

printf '\n\033[1m%d passed, %d warnings, %d blocking\033[0m\n' "$pass" "$warn" "$fail"
if [ "$fail" -gt 0 ]; then
  printf 'Not ready: fix the ✗ items.\n'; exit 1
fi
printf 'No blocking issues. Review the ! items before submitting.\n'
