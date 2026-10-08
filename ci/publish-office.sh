#!/usr/bin/env bash
# Upload a finished Nubo Office build (Flatpak repository + bundle) to R2.
# Usage: ci/publish-office.sh VERSION [ARCH]      e.g. ci/publish-office.sh 26.04.3.3-nubo1 x86_64
# Reads the build from WORK (default /var/tmp/nubo-office). Environment: R2_ACCESS_KEY_ID,
# R2_SECRET_ACCESS_KEY, R2_ENDPOINT (and optionally R2_BUCKET).
set -euo pipefail
cd "$(dirname "$0")/.."
VER="${1:?version, for example 26.04.3.3-nubo1}"
ARCH_FP="${2:-$(uname -m)}"
WORK="${WORK:-/var/tmp/nubo-office}"
REPO="${WORK}/repo"; BUNDLE_DIR="${WORK}/bundle"; BUNDLE="nubo-office-${VER}-${ARCH_FP}.flatpak"

# Refuse to publish anything incomplete or unsigned.
for f in "${BUNDLE_DIR}/${BUNDLE}" "${BUNDLE_DIR}/${BUNDLE}.sha256" "${BUNDLE_DIR}/latest-${ARCH_FP}.json" "${REPO}/summary" "${REPO}/summary.sig"; do
  [[ -f "$f" ]] || { echo "Cannot publish: missing $f" >&2; exit 1; }
done
(cd "${BUNDLE_DIR}" && sha256sum -c "${BUNDLE}.sha256")

. ci/rclone-env.sh
echo "==> Uploading to r2:${R2_BUCKET}/flatpak"
rclone sync "${REPO}" "r2:${R2_BUCKET}/flatpak" --fast-list --transfers 16 \
  --header-upload "Cache-Control: public, max-age=300"
rclone copy "${BUNDLE_DIR}" "r2:${R2_BUCKET}/dl/office/${VER}" --exclude 'latest-*.json' \
  --header-upload "Cache-Control: public, max-age=3600"
# The website reads this to show the download.
rclone copyto "${BUNDLE_DIR}/latest-${ARCH_FP}.json" "r2:${R2_BUCKET}/dl/office/latest-${ARCH_FP}.json" \
  --header-upload "Cache-Control: public, max-age=60"
echo "Add it with: flatpak remote-add --if-not-exists nubo https://archive.nubosuite.tech/flatpak/nubo.flatpakrepo"
echo "Download: https://archive.nubosuite.tech/dl/office/${VER}/${BUNDLE}"
