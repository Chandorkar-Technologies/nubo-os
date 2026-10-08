#!/usr/bin/env bash
# Render the scratch cards with headless Chrome.
#   out/<p>-card.pdf        front + back, 111 x 154 mm (105 x 148 mm A6 plus 3 mm bleed). Send this to the printer.
#   out/<p>-card-under.pdf  the back as printed under the silver coating (proof for the printer)
#   out/<p>-card-front.png, <p>-card-back.png   previews for sharing
# Usage: ./build.sh [os|office]
set -euo pipefail
cd "$(dirname "$0")"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
mkdir -p out
run() { "$CHROME" --headless=new --disable-gpu --hide-scrollbars --virtual-time-budget=15000 "$@" >/dev/null 2>&1; }
for p in ${@:-os office}; do
  u="file://$PWD/card.html?p=$p"
  run --no-pdf-header-footer --print-to-pdf="out/$p-card.pdf" "$u"
  run --no-pdf-header-footer --print-to-pdf="out/$p-card-under.pdf" "$u&key=1"
  echo "built $p"
done
