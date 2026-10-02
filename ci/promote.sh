#!/usr/bin/env bash
# Copy what the beta channel carries into stable. No rebuild.
set -euo pipefail
. "$(dirname "$0")/rclone-env.sh"
repo/publish.sh --promote
