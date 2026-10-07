#!/usr/bin/env bash
# Drone entry point for the Nubo Office build. Kept in a script so Drone's own ${...}
# substitution never sees our variables.
# Usage: ci/build-office-tag.sh office-26.04.3.3-1
#   tag office-26.04.3.3-1 builds upstream coda-26.04.3.3-1 as version 26.04.3.3-nubo1
set -euo pipefail
cd "$(dirname "$0")/.."
# Drone runs this as root. The Flatpak build must not run as root (see build-office.sh), so
# hand over to the ordinary build user, keeping the secrets in the environment.
if [[ "$(id -u)" -eq 0 ]]; then
  BUILD_USER="${BUILD_USER:-nubo}"
  chown -R "${BUILD_USER}" "$PWD" 2>/dev/null || true
  exec sudo -E -u "${BUILD_USER}" env "PATH=${PATH}" "$PWD/ci/build-office-tag.sh" "$@"
fi
TAG="${1:?tag, for example office-26.04.3.3-1}"
REL="${TAG#office-}"
UPSTREAM="coda-${REL}"
VERSION="${REL%-*}-nubo${REL##*-}"
echo "Upstream ${UPSTREAM}, version ${VERSION}"
if [[ -n "${GPG_KEY:-}" ]]; then
  echo "${GPG_KEY}" | gpg --batch --import
  GPG_KEY_ID="$(gpg --list-secret-keys --with-colons | awk -F: '/^fpr/{print $10; exit}')"
  export GPG_KEY_ID
  echo "Signing with key ${GPG_KEY_ID}"
fi
exec ci/build-office.sh "${UPSTREAM}" "${VERSION}"
