#!/usr/bin/env bash
# Build the Nubo websites and publish them to R2 (www/ and os/ in the nubo-archive bucket).
# The nubo-web Worker serves them at nubosuite.tech and os.nubosuite.tech (source: website/worker.js).
set -euo pipefail
cd "$(dirname "$0")/../website"
. ../ci/rclone-env.sh
npm ci --no-audit --no-fund
python3 tools/make-releases.py
python3 build.py
rclone sync dist/www "r2:${R2_BUCKET}/www" --fast-list --checksum
rclone sync dist/os "r2:${R2_BUCKET}/os" --fast-list --checksum
echo "Published: https://nubosuite.tech and https://os.nubosuite.tech"
