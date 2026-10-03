#!/usr/bin/env bash
# Remove the staged packages once both the archive and the images are done.
set -euo pipefail
. "$(dirname "$0")/rclone-env.sh"
rclone purge "r2:${R2_BUCKET}/_staging/${DRONE_TAG:?}"
