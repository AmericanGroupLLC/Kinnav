#!/usr/bin/env bash
# =====================================================================
#  Kinnav · wire up Google Sign-In for iOS
# =====================================================================
#
#  Run from the project root, after `firebase login`:
#      ./tools/setup_google_signin.sh
#
#  What is broken without this
#  ---------------------------
#  `AppConfig.googleIosClientId` defaults to '' so GoogleSignIn is constructed
#  with `clientId: null`, and the SDK then expects to come back through the
#  reversed-client-id URL scheme in Info.plist. That scheme is not there — the
#  placeholder was deleted — so on iOS "Continue with Google" has no way to
#  return to the app. Apple sign-in and email/password are unaffected.
#
#  Separately, the OAuth client compiled into app_config.dart
#  (146431650883-…) belongs to a *different* Google Cloud project than
#  americangroupllc-5bdfc (project number 9057515422). An OAuth client id is
#  prefixed with its project number, so those cannot both be right.
#
#  What this does
#  --------------
#   1. finds or creates the Firebase iOS app for the bundle id
#   2. downloads GoogleService-Info.plist into ios/Runner/
#   3. registers it in the Runner target so it ships inside the .app
#   4. adds CFBundleURLTypes with the real REVERSED_CLIENT_ID
#   5. rewrites the Google client ids in lib/config/app_config.dart
#
#  Idempotent: re-running finds the existing app and rewrites the same values.
set -euo pipefail
cd "$(dirname "$0")/.."

BUNDLE_ID="com.americangroupllc.kinnav"
PROJECT="americangroupllc-5bdfc"
PLIST="ios/Runner/GoogleService-Info.plist"

command -v firebase >/dev/null || { echo "✗ firebase CLI not found"; exit 1; }
if ! firebase login:list 2>/dev/null | grep -qi '@'; then
  echo "✗ Not signed in. Run:  firebase login"; exit 1
fi

echo "==> locating the iOS app in $PROJECT"
APP_ID="$(firebase apps:list IOS --project "$PROJECT" 2>/dev/null \
  | awk -v b="$BUNDLE_ID" -F'│' '$0 ~ b {gsub(/ /,"",$3); print $3}' | head -1)"

if [ -z "$APP_ID" ]; then
  echo "    none registered — creating one"
  firebase apps:create IOS "Kinnav" --bundle-id "$BUNDLE_ID" --project "$PROJECT"
  APP_ID="$(firebase apps:list IOS --project "$PROJECT" 2>/dev/null \
    | awk -v b="$BUNDLE_ID" -F'│' '$0 ~ b {gsub(/ /,"",$3); print $3}' | head -1)"
fi
[ -n "$APP_ID" ] || { echo "✗ could not determine the iOS app id"; exit 1; }
echo "    app id: $APP_ID"

echo "==> downloading GoogleService-Info.plist"
firebase apps:sdkconfig IOS "$APP_ID" --project "$PROJECT" --out "$PLIST"
[ -s "$PLIST" ] || { echo "✗ $PLIST is empty"; exit 1; }

CLIENT_ID="$(/usr/libexec/PlistBuddy -c 'Print :CLIENT_ID' "$PLIST" 2>/dev/null || true)"
REVERSED="$(/usr/libexec/PlistBuddy -c 'Print :REVERSED_CLIENT_ID' "$PLIST" 2>/dev/null || true)"
[ -n "$CLIENT_ID" ] && [ -n "$REVERSED" ] || {
  echo "✗ plist has no CLIENT_ID/REVERSED_CLIENT_ID — Google sign-in is probably"
  echo "  not enabled for this app in the Firebase console"; exit 1; }
echo "    CLIENT_ID           $CLIENT_ID"
echo "    REVERSED_CLIENT_ID  $REVERSED"

echo "==> registering the plist in the Runner target"
bundle exec ruby -e '
require "xcodeproj"
plist, proj_path = ARGV
project = Xcodeproj::Project.open(proj_path)
target  = project.targets.find { |t| t.name == "Runner" }
name    = File.basename(plist)
already = target.resources_build_phase.files.any? { |f| f.display_name == name }
if already
  puts "    already a bundle resource"
else
  group = project.main_group.find_subpath("Runner", true)
  ref   = group.files.find { |f| f.display_name == name } || group.new_reference(name)
  target.resources_build_phase.add_file_reference(ref, true)
  project.save
  puts "    added to Copy Bundle Resources"
end' "$PLIST" ios/Runner.xcodeproj

echo "==> adding the URL scheme to Info.plist"
python3 - "$REVERSED" <<'PY'
import subprocess, sys
rev = sys.argv[1]; p = 'ios/Runner/Info.plist'
def pb(*a):
    return subprocess.run(['/usr/libexec/PlistBuddy', *a, p],
                          capture_output=True, text=True)
# Rebuild the array from scratch so re-runs cannot append duplicates — a second
# scheme with the same value makes iOS pick one arbitrarily.
pb('-c', 'Delete :CFBundleURLTypes')
pb('-c', 'Add :CFBundleURLTypes array')
pb('-c', 'Add :CFBundleURLTypes:0 dict')
pb('-c', 'Add :CFBundleURLTypes:0:CFBundleTypeRole string Editor')
pb('-c', 'Add :CFBundleURLTypes:0:CFBundleURLSchemes array')
pb('-c', f'Add :CFBundleURLTypes:0:CFBundleURLSchemes:0 string {rev}')
out = pb('-c', 'Print :CFBundleURLTypes:0:CFBundleURLSchemes:0').stdout.strip()
print(f"    scheme: {out}")
assert out == rev, "URL scheme did not stick"
PY

echo "==> updating client ids in lib/config/app_config.dart"
python3 - "$CLIENT_ID" <<'PY'
import re, sys
ios_client = sys.argv[1]
p = 'lib/config/app_config.dart'; s = open(p).read()
# The iOS client id is the one the native SDK needs; the server/web client id
# is a different credential and must keep matching Supabase's Google provider,
# so it is deliberately left alone here.
s = re.sub(r"(googleIosClientId = String\.fromEnvironment\(\s*'GOOGLE_IOS_CLIENT_ID',\s*defaultValue:\s*)'[^']*'",
           lambda m: m.group(1) + f"'{ios_client}'", s, count=1)
open(p, 'w').write(s)
print(f"    googleIosClientId = {ios_client}")
PY

echo
echo "✓ done. Next:"
echo "   flutter analyze && flutter test"
echo "   bundle exec fastlane ios build"
echo
echo "Still manual — these live in consoles this script cannot reach:"
echo "   • Supabase → Auth → Providers → Google: set the *web* client id"
echo "   • OAuth consent screen: rename 'project-9057515422' to Kinnav"
