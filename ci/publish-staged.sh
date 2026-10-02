#!/usr/bin/env bash
# Collect the staged packages of both architectures and publish the archive.
set -euo pipefail
TAG="${1:?tag}"
. "$(dirname "$0")/rclone-env.sh"
rm -rf debs && mkdir debs
rclone copy "r2:${R2_BUCKET}/_staging/${TAG}" debs
ls debs
repo/publish.sh debs beta
rclone purge "r2:${R2_BUCKET}/_staging/${TAG}"
