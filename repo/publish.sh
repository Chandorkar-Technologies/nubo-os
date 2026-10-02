#!/usr/bin/env bash
# Build the signed apt archive and upload it to Cloudflare R2 (archive.nubosuite.tech).
# Usage: publish.sh DEBS_DIR [stable|beta]
#   beta   -> suite resolute-beta (testers)
#   stable -> suite resolute      (everyone); publish the same debs after beta is happy
# Needs: reprepro, gpg (key imported), rclone with remote "nubo-r2".
# Env:   R2_BUCKET (default nubo-archive), SKIP_UPLOAD=1 to only build locally.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
DEBS="$(readlink -f "${1:?directory with .deb files}")"
CHANNEL="${2:-beta}"
case "${CHANNEL}" in stable) SUITE=resolute ;; beta) SUITE=resolute-beta ;; *) echo "channel: stable|beta" >&2; exit 1 ;; esac
OUT="${OUT:-${HERE}/out}"
BUCKET="${R2_BUCKET:-nubo-archive}"

rm -rf "${OUT}"; mkdir -p "${OUT}"
cp -r "${HERE}/conf" "${OUT}/conf"
# The archive is rebuilt from scratch each time, so first fetch every package
# already published (pool/) and put them back, then add the new ones. Both
# suites are re-indexed from what each one has published.
PREV="$(mktemp -d)"
if [[ -z "${SKIP_UPLOAD:-}" ]]; then
  rclone copy "nubo-r2:${BUCKET}/pool" "${PREV}/pool" --fast-list 2>/dev/null || true
  rclone copy "nubo-r2:${BUCKET}/suites" "${PREV}/suites" 2>/dev/null || true
fi
# suites/<suite>.list holds the file names each suite carried last time.
for s in resolute resolute-beta; do
  [[ -f "${PREV}/suites/${s}.list" ]] || continue
  while read -r name; do
    f="$(find "${PREV}/pool" -name "${name}" -print -quit)"
    [[ -n "${f}" ]] && reprepro -b "${OUT}" includedeb "${s}" "${f}"
  done <"${PREV}/suites/${s}.list"
done
for deb in "${DEBS}"/*.deb; do reprepro -b "${OUT}" includedeb "${SUITE}" "${deb}"; done
mkdir -p "${OUT}/suites"
for s in resolute resolute-beta; do
  reprepro -b "${OUT}" --list-format '${filekey}\n' list "${s}" | xargs -n1 basename | sort -u >"${OUT}/suites/${s}.list"
done
rm -rf "${OUT}/db" "${OUT}/conf"
cp "${HERE}/nubo-archive-keyring.asc" "${OUT}/" 2>/dev/null || true
[[ -n "${SKIP_UPLOAD:-}" ]] && { echo "Archive built in ${OUT}"; exit 0; }
rclone copy "${OUT}" "nubo-r2:${BUCKET}" --fast-list --checksum
echo "Published ${CHANNEL} to archive.nubosuite.tech"
