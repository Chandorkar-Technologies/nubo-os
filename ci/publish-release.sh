#!/usr/bin/env bash
# After every architecture has uploaded its images: write the release manifest,
# the signed checksum list, and point the channel at this release.
# Usage: ci/publish-release.sh VERSION    (channel: beta if VERSION has a dash, else stable)
# Needs rclone, python3, and (to sign) gpg with the Nubo key imported.
set -euo pipefail
cd "$(dirname "$0")/.."
. ci/rclone-env.sh
VER="${1:?version}"
case "${VER}" in *-*) CHANNEL=beta ;; *) CHANNEL=stable ;; esac
BASE=https://archive.nubosuite.tech/dl
W="$(mktemp -d)"; trap 'rm -rf "${W}"' EXIT

rclone lsjson "r2:${R2_BUCKET}/dl/${VER}" >"${W}/list.json"
rclone copy "r2:${R2_BUCKET}/dl/${VER}" "${W}/sums" --include '*.sha256'
python3 ci/make-manifest.py "${VER}" "${W}/list.json" "${W}/sums" "${BASE}" >"${W}/manifest.json"
cat "${W}"/sums/*.sha256 | sort -k2 >"${W}/SHA256SUMS"
if gpg --list-secret-keys >/dev/null 2>&1 && [[ -n "$(gpg --list-secret-keys 2>/dev/null)" ]]; then
  gpg --batch --yes --armor --detach-sign -o "${W}/SHA256SUMS.asc" "${W}/SHA256SUMS"
fi
rclone copy "${W}" "r2:${R2_BUCKET}/dl/${VER}" --include manifest.json --include SHA256SUMS --include SHA256SUMS.asc \
  --header-upload "Cache-Control: public, max-age=300"

printf '{"channel":"%s","version":"%s","manifest":"%s/%s/manifest.json","updated":"%s"}\n' \
  "${CHANNEL}" "${VER}" "${BASE}" "${VER}" "$(date -u +%FT%TZ)" >"${W}/${CHANNEL}.json"
rclone copyto "${W}/${CHANNEL}.json" "r2:${R2_BUCKET}/dl/channels/${CHANNEL}.json" --header-upload "Cache-Control: public, max-age=60"
echo "Release ${VER} is the ${CHANNEL} release."
ci/deploy-web.sh
