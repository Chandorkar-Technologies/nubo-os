#!/usr/bin/env bash
# Make the beta release the stable release. No rebuild: only the pointer moves.
# Images keep the version they were built and tested as (for example 0.8.0-beta5).
set -euo pipefail
cd "$(dirname "$0")/.."
. ci/rclone-env.sh
rclone copyto "r2:${R2_BUCKET}/dl/channels/beta.json" "r2:${R2_BUCKET}/dl/channels/stable.json" --header-upload "Cache-Control: public, max-age=60"
rclone cat "r2:${R2_BUCKET}/dl/channels/stable.json"
ci/deploy-web.sh
