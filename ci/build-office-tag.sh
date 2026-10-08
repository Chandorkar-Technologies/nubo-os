#!/usr/bin/env bash
# Drone entry point for the Nubo Office build. Kept in a script so Drone's own ${...}
# substitution never sees our variables.
# Usage: ci/build-office-tag.sh office-26.04.3.3-1
#   tag office-26.04.3.3-1 builds upstream coda-26.04.3.3-1 as version 26.04.3.3-nubo1
# NUBO_DRY_RUN=1 prints what would be built and stops.
set -euo pipefail
cd "$(dirname "$0")/.."
TAG="${1:?tag, for example office-26.04.3.3-1}"
SECRET_VARS=(GPG_KEY R2_ACCESS_KEY_ID R2_SECRET_ACCESS_KEY R2_ENDPOINT R2_BUCKET NUBO_DRY_RUN WORK)

# Drone runs this as root, in a private folder. The Flatpak build must not run as root
# (see build-office.sh), so copy the checkout somewhere the build user owns and hand over.
# sudo here ignores -E, so the secrets travel in a file only the build user can read,
# which it deletes as soon as it has read it.
if [[ "$(id -u)" -eq 0 ]]; then
  BUILD_USER="${BUILD_USER:-nubo}"
  JOB="$(mktemp -d /var/tmp/nubo-office-job.XXXXXX)"
  cp -a "$PWD/." "${JOB}/"
  ( umask 077; : > "${JOB}/.job-env"
    for v in "${SECRET_VARS[@]}"; do
      [[ -n "${!v:-}" ]] && printf 'export %s=%q\n' "$v" "${!v}" >> "${JOB}/.job-env"
    done; true )
  chown -R "${BUILD_USER}" "${JOB}"
  sudo -u "${BUILD_USER}" "${JOB}/ci/build-office-tag.sh" "$@" && rc=0 || rc=$?
  rm -rf "${JOB}"
  exit "${rc}"
fi
if [[ -f "${PWD}/.job-env" ]]; then . "${PWD}/.job-env"; rm -f "${PWD}/.job-env"; fi

REL="${TAG#office-}"
UPSTREAM="coda-${REL}"
VERSION="${REL%-*}-nubo${REL##*-}"
echo "Upstream ${UPSTREAM}, version ${VERSION}, running as $(id -un)"
if [[ -n "${GPG_KEY:-}" ]]; then
  # the fingerprint of the key we were given, not whichever key happens to be first in the keyring
  GPG_KEY_ID="$(printf '%s\n' "${GPG_KEY}" | gpg --batch --show-keys --with-colons | awk -F: '/^fpr/{print $10; exit}')"
  printf '%s\n' "${GPG_KEY}" | gpg --batch --import
  export GPG_KEY_ID
  echo "Signing with key ${GPG_KEY_ID}"
fi
WORK="${WORK:-/var/tmp/nubo-office}"; export WORK
READY="${WORK}/ready-${VERSION}-$(uname -m)"
if [[ -f "${READY}" ]]; then
  # A finished, checked build of exactly this version is already here: upload it, do not rebuild for hours.
  BUNDLE="nubo-office-${VERSION}-$(uname -m).flatpak"
  [[ "$(cut -d' ' -f1 "${READY}")" == "$(sha256sum "${WORK}/bundle/${BUNDLE}" | cut -d' ' -f1)" ]] \
    || { echo "The finished build does not match its checksum; refusing to publish it." >&2; exit 1; }
  echo "Finished build of ${VERSION} found; uploading it."
  [[ -n "${NUBO_DRY_RUN:-}" ]] && { echo "dry run: would upload ${BUNDLE}; R2 set: ${R2_ENDPOINT:+yes}"; exit 0; }
  ci/publish-office.sh "${VERSION}"
  exit 0
fi
[[ -n "${NUBO_DRY_RUN:-}" ]] && { echo "dry run: would build ${UPSTREAM} as ${VERSION}; R2 set: ${R2_ENDPOINT:+yes}"; exit 0; }
ci/build-office.sh "${UPSTREAM}" "${VERSION}"
