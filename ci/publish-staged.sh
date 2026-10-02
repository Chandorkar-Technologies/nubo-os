#!/usr/bin/env bash
# Collect the staged packages of both architectures and publish the archive.
set -euo pipefail
TAG="${1:?tag}"
. "$(dirname "$0")/rclone-env.sh"
case "${TAG}" in *-*) CHANNEL=beta ;; *) CHANNEL=stable ;; esac
rm -rf debs && mkdir debs
rclone copy "nubo-r2:${R2_BUCKET}/_staging/${TAG}" debs
ls debs
repo/publish.sh debs "${CHANNEL}"
rclone purge "nubo-r2:${R2_BUCKET}/_staging/${TAG}"
