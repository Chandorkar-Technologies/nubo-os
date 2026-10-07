#!/usr/bin/env bash
# Drone entry point for the Nubo Office build. Kept in a script so Drone's own ${...}
# substitution never sees our variables.
# Usage: ci/build-office-tag.sh office-26.04.3.3-1
#   tag office-26.04.3.3-1 builds upstream coda-26.04.3.3-1 as version 26.04.3.3-nubo1
set -euo pipefail
cd "$(dirname "$0")/.."
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
