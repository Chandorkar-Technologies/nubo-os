#!/usr/bin/env bash
# Render the flyers with headless Chrome. Source: flyer.html (one file, three flyers).
#   out/<name>-a4-print.pdf   light background, for the printer (little ink, no full-page dark)
#   out/<name>-a4-dark.pdf    dark, for email and screens
#   out/<name>-a4-dark.png    dark, for sharing
#   out/<name>-social.png     1080x1350 (4:5) for Instagram, LinkedIn, Facebook
# Usage: ./build.sh            builds everything
#        ./build.sh office     builds one flyer (os, office or bundle)
set -euo pipefail
cd "$(dirname "$0")"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
mkdir -p out
run() { "$CHROME" --headless=new --disable-gpu --hide-scrollbars --virtual-time-budget=15000 "$@" >/dev/null 2>&1; }
for f in ${@:-os office bundle}; do
  u="file://$PWD/flyer.html?f=$f"
  run --no-pdf-header-footer --print-to-pdf="out/$f-a4-print.pdf" "$u&theme=light&size=a4"
  run --no-pdf-header-footer --print-to-pdf="out/$f-a4-dark.pdf"  "$u&theme=dark&size=a4"
  run --window-size=794,1123 --force-device-scale-factor=3 --screenshot="out/$f-a4-dark.png" "$u&theme=dark&size=a4"
  run --window-size=1080,1350 --force-device-scale-factor=1 --screenshot="out/$f-social.png" "$u&theme=dark&size=social"
  echo "built $f"
done
