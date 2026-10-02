#!/usr/bin/env bash
# Put this architecture's built packages in the bucket's staging area.
# amd64 uploads everything (the "all" packages included); arm64 only its own.
set -euo pipefail
ARCH="${1:?arch}"; DIR="${2:?dir}"
. "$(dirname "$0")/rclone-env.sh"
TAG="${DRONE_TAG:?}"
if [[ "${ARCH}" == amd64 ]]; then
  rclone copy "${DIR}" "nubo-r2:${R2_BUCKET}/_staging/${TAG}" --include '*.deb'
else
  rclone copy "${DIR}" "nubo-r2:${R2_BUCKET}/_staging/${TAG}" --include '*_arm64.deb'
fi
