#!/usr/bin/env bash
# =====================================================================
#  Kinnav · Google Play feature graphic + store icon generator
# =====================================================================
#
#  Run from the project root:
#      ./tools/gen_feature_graphic.sh
#
#  Outputs (both required by Play before a listing can go live):
#      fastlane/metadata/android/en-US/images/featureGraphic.png  1024x500
#      fastlane/metadata/android/en-US/images/icon.png            512x512
#
#  Play spec notes this satisfies:
#    * feature graphic is exactly 1024x500 PNG with NO alpha channel
#      (Play rejects transparency outright)
#    * icon is 512x512 PNG, also flattened
#    * critical content stays inside the middle ~80%: Play crops the edges
#      on some surfaces, and a wordmark touching the border gets clipped
#
#  Built from the real brand lockup in assets/logo rather than redrawn, so
#  the typeface and the shield cannot drift from the app's own artwork.
#
#  Requires ImageMagick 7 (`magick`).
set -euo pipefail

cd "$(dirname "$0")/.."

LOGO="assets/logo/kinnav_logo.png"     # shield + "Kinnav" + tagline lockup
ICON_SRC="assets/logo/app_icon_1024.png"
OUT_DIR="fastlane/metadata/android/en-US/images"

command -v magick >/dev/null || { echo "✗ ImageMagick (magick) not found"; exit 1; }
[ -f "$LOGO" ] || { echo "✗ missing $LOGO"; exit 1; }
[ -f "$ICON_SRC" ] || { echo "✗ missing $ICON_SRC"; exit 1; }

mkdir -p "$OUT_DIR"

# Brand palette — mirrors AppColors in lib/theme/app_theme.dart.
LAVENDER_BG="#FAF5FF"   # AppColors.lavenderBg
LAVENDER_CARD="#EFE0FB" # AppColors.lavenderCard
PRIMARY="#BF6EEE"       # AppColors.primary

# 1024x500 diagonal wash from the app's own scaffold tint into the card fill,
# so the graphic reads as the same surface the app opens on.
magick -size 1024x500 \
  gradient:"$LAVENDER_BG"-"$LAVENDER_CARD" \
  -rotate 90 -resize 1024x500\! \
  /tmp/kinnav_fg_bg.png

# The lockup at 78% width keeps it clear of Play's edge cropping.
magick /tmp/kinnav_fg_bg.png \
  \( "$LOGO" -resize 800x \) -gravity center -geometry +0-10 -composite \
  -stroke "$PRIMARY" -strokewidth 6 -draw "line 0,494 1024,494" \
  -alpha remove -alpha off \
  PNG24:"$OUT_DIR/featureGraphic.png"

# Play's store icon: 512x512, flattened onto white so the rounded corners of
# the source do not show as black after alpha removal.
magick "$ICON_SRC" -resize 512x512 \
  -background white -alpha remove -alpha off \
  PNG24:"$OUT_DIR/icon.png"

rm -f /tmp/kinnav_fg_bg.png

echo "✓ wrote:"
for f in "$OUT_DIR/featureGraphic.png" "$OUT_DIR/icon.png"; do
  printf '   %-60s %s\n' "$f" "$(magick identify -format '%wx%h %[channels]' "$f")"
done
