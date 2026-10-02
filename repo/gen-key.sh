#!/usr/bin/env bash
# One-time: create the archive signing key. The PRIVATE key never goes in git:
# store it in a password manager and as the CI secret NUBO_GPG_PRIVATE_KEY.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
export GNUPGHOME="$(mktemp -d)"
gpg --batch --pinentry-mode loopback --passphrase '' --quick-generate-key \
  "Nubo OS Archive <security@nubosuite.tech>" ed25519 sign 5y
KEYID="$(gpg --list-keys --with-colons | awk -F: '/^fpr/{print $10; exit}')"
gpg --export "${KEYID}" >"${HERE}/nubo-archive-keyring.gpg"
gpg --armor --export "${KEYID}" >"${HERE}/nubo-archive-keyring.asc"
gpg --armor --export-secret-keys "${KEYID}" >"${HERE}/PRIVATE-nubo-archive-key.asc"
echo "Public key written to repo/. Fingerprint: ${KEYID}"
echo "Move repo/PRIVATE-nubo-archive-key.asc to a safe place and DELETE it from this folder."
