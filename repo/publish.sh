#!/usr/bin/env bash
# Build the signed apt archive and upload it to Cloudflare R2 (archive.nubosuite.tech).
# Usage: publish.sh DEBS_DIR beta     add new packages to the beta channel (resolute-beta)
#        publish.sh --promote          copy everything beta carries into stable (resolute)
# Stable is only ever filled by promoting what beta already carries, so the two
# channels never hold different builds of the same version.
# Every release needs a NEW version in debian/changelog: a package file with the
# same name but different contents is refused (the pool is shared by both channels).
# Needs: reprepro, gpg (key imported), rclone with remote "r2".
# Env:   R2_BUCKET (default nubo-archive), SKIP_UPLOAD=1 to only build locally.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
if [[ "${1:-}" == "--promote" ]]; then
  MODE=promote; CHANNEL=stable; SUITE=resolute; DEBS=/nonexistent
else
  MODE=add; DEBS="$(readlink -f "${1:?directory with .deb files, or --promote}")"; CHANNEL="${2:-beta}"
  [[ "${CHANNEL}" == beta ]] || { echo "new packages go to beta; use --promote for stable" >&2; exit 1; }
  SUITE=resolute-beta
fi
OUT="${OUT:-${HERE}/out}"
BUCKET="${R2_BUCKET:-nubo-archive}"

rm -rf "${OUT}"; mkdir -p "${OUT}"
cp -r "${HERE}/conf" "${OUT}/conf"
# The archive is rebuilt from scratch each time, so first fetch every package
# already published (pool/) and put them back, then add the new ones. Both
# suites are re-indexed from what each one has published.
PREV="${PREV_DIR:-$(mktemp -d)}"   # PREV_DIR: a local copy of the published archive (tests)
if [[ -z "${SKIP_UPLOAD:-}" && -z "${PREV_DIR:-}" ]]; then
  rclone copy "r2:${BUCKET}/pool" "${PREV}/pool" --fast-list 2>/dev/null || true
  rclone copy "r2:${BUCKET}/suites" "${PREV}/suites" 2>/dev/null || true
fi
# suites/<suite>.list holds the file names each suite carried last time.
for s in resolute resolute-beta; do
  [[ -f "${PREV}/suites/${s}.list" ]] || continue
  while read -r name; do
    f="$(find "${PREV}/pool" -name "${name}" -print -quit)"
    [[ -n "${f}" ]] && reprepro -b "${OUT}" includedeb "${s}" "${f}"
  done <"${PREV}/suites/${s}.list"
done
if [[ "${MODE}" == promote ]]; then
  [[ -f "${PREV}/suites/resolute-beta.list" ]] || { echo "beta carries nothing to promote" >&2; exit 1; }
  while read -r name; do
    f="$(find "${PREV}/pool" -name "${name}" -print -quit)"
    [[ -n "${f}" ]] && reprepro -b "${OUT}" includedeb resolute "${f}"
  done <"${PREV}/suites/resolute-beta.list"
else
  for deb in "${DEBS}"/*.deb; do reprepro -b "${OUT}" includedeb "${SUITE}" "${deb}"; done
fi
mkdir -p "${OUT}/suites"
for s in resolute resolute-beta; do
  # file names this suite carries, read from its package indices
  { for idx in "${OUT}/dists/${s}"/main/binary-*/Packages.gz; do [[ -f "${idx}" ]] && gzip -dc "${idx}"; done; } \
    | awk '/^Filename:/{n=split($2,p,"/"); print p[n]}' | sort -u >"${OUT}/suites/${s}.list" || true
done
rm -rf "${OUT}/db" "${OUT}/conf"
cp "${HERE}/nubo-archive-keyring.asc" "${OUT}/" 2>/dev/null || true
[[ -n "${SKIP_UPLOAD:-}" ]] && { echo "Archive built in ${OUT}"; exit 0; }
# Package files never change (every release has a new version), so they may be
# cached for good. The indexes change on every publish: keep them fresh.
rclone copy "${OUT}/pool" "r2:${BUCKET}/pool" --fast-list --checksum \
  --header-upload "Cache-Control: public, max-age=31536000, immutable"
rclone copy "${OUT}" "r2:${BUCKET}" --exclude "pool/**" --fast-list --checksum \
  --header-upload "Cache-Control: public, max-age=60"
echo "Published ${CHANNEL} to archive.nubosuite.tech"
