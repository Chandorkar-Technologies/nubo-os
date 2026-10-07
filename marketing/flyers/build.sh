#!/usr/bin/env bash
# Render the flyers to PDF (print) and PNG (share) with headless Chrome.
# Usage: ./build.sh            builds every flyer
#        ./build.sh nubo-os    builds one
set -euo pipefail
cd "$(dirname "$0")"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
mkdir -p out
for name in ${@:-nubo-os nubo-office}; do
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --no-pdf-header-footer \
    --virtual-time-budget=15000 --print-to-pdf="out/${name}.pdf" "file://$PWD/${name}.html" >/dev/null 2>&1
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --virtual-time-budget=15000 \
    --window-size=794,1123 --force-device-scale-factor=3 --screenshot="out/${name}.png" "file://$PWD/${name}.html" >/dev/null 2>&1
  echo "built out/${name}.pdf and out/${name}.png"
done
