#!/bin/sh
# Point a system's apt at Nubo Cumulus instead of Ubuntu's own servers.
# Usage: use-cumulus.sh [ROOT]   (ROOT: an unpacked system such as a chroot; default /)
# Cumulus is listed first and Ubuntu second (mirrors.txt), so a Cumulus outage
# does not stop a build. Safe to run again.
set -eu
ROOT="${1:-}"
case "$(chroot "${ROOT:-/}" dpkg --print-architecture 2>/dev/null || dpkg --print-architecture)" in
  arm64) PATHNAME=cumulus-arm ;;
  *)     PATHNAME=cumulus ;;
esac
NEW="mirror+https://archive.nubosuite.tech/${PATHNAME}/mirrors.txt"

# Reading https needs root certificates, which a bare container may lack. Get
# them first from the existing source, then switch.
if [ ! -f "${ROOT}/etc/ssl/certs/ca-certificates.crt" ]; then
  chroot "${ROOT:-/}" sh -c 'apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq ca-certificates' >/dev/null
fi
# apt's mirror+ method ships inside apt itself; nothing else to install.

for f in "${ROOT}"/etc/apt/sources.list.d/ubuntu.sources "${ROOT}"/etc/apt/sources.list; do
  [ -f "$f" ] || continue
  sed -i -E \
    -e "s#(URIs:[[:space:]]*)https?://([a-z]{2}\.)?archive\.ubuntu\.com/ubuntu/?#\1${NEW}#" \
    -e "s#(URIs:[[:space:]]*)https?://security\.ubuntu\.com/ubuntu/?#\1${NEW}#" \
    -e "s#(URIs:[[:space:]]*)https?://ports\.ubuntu\.com/ubuntu-ports/?#\1${NEW}#" \
    -e "s#https?://([a-z]{2}\.)?archive\.ubuntu\.com/ubuntu/?#https://archive.nubosuite.tech/${PATHNAME}#g" \
    -e "s#https?://security\.ubuntu\.com/ubuntu/?#https://archive.nubosuite.tech/${PATHNAME}#g" \
    -e "s#https?://ports\.ubuntu\.com/ubuntu-ports/?#https://archive.nubosuite.tech/${PATHNAME}#g" \
    "$f"
done
echo "apt now uses Nubo Cumulus (${PATHNAME})"
