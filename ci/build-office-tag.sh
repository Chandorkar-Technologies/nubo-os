#!/usr/bin/env bash
# Drone entry point for the Nubo Office build. Kept in a script so Drone's own ${...}
# substitution never sees our variables.
# Usage: ci/build-office-tag.sh office-26.04.3.3-1
#   tag office-26.04.3.3-1 builds upstream coda-26.04.3.3-1 as version 26.04.3.3-nubo1
# NUBO_DRY_RUN=1 prints what would be built and stops.
set -euo pipefail
cd "$(dirname "$0")/.."
TAG="${1:?tag, for example office-26.04.3.3-1}"

# Drone runs this as root, in a private folder. The Flatpak build must not run as root
# (see build-office.sh), so copy the checkout somewhere the build user owns and hand over,
# keeping the secrets in the environment.
if [[ "$(id -u)" -eq 0 ]]; then
  BUILD_USER="${BUILD_USER:-nubo}"
  JOB="$(mktemp -d /var/tmp/nubo-office-job.XXXXXX)"
  cp -a "$PWD/." "${JOB}/"
  chown -R "${BUILD_USER}" "${JOB}"
  exec sudo -E -u "${BUILD_USER}" env "PATH=${PATH}" "${JOB}/ci/build-office-tag.sh" "$@"
fi

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
[[ -n "${NUBO_DRY_RUN:-}" ]] && { echo "dry run: would build ${UPSTREAM} as ${VERSION}"; exit 0; }
exec ci/build-office.sh "${UPSTREAM}" "${VERSION}"
