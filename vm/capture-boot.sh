#!/usr/bin/env bash
# Reboot the dev VM and capture a frame every second while it starts, so the
# boot screen can be reviewed.
# Usage: vm/capture-boot.sh OUTPUT_DIR [FRAMES]

set -euo pipefail

OUT="${1:?output directory required}"
FRAMES="${2:-16}"
# Local settings (Proxmox host etc.) can live outside the repository.
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env" ]] && . "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env"
PVE_HOST="${PVE_HOST:?set PVE_HOST to the Proxmox host, e.g. root@proxmox.example.net}"
VMID="${VMID:-301}"

# Resolve before changing directory, so relative paths mean what the caller meant.
case "${OUT}" in /*) ;; *) OUT="${PWD}/${OUT}" ;; esac
cd "$(dirname "$0")"
mkdir -p "${OUT}"

ssh -o BatchMode=yes "${PVE_HOST}" "qm reboot ${VMID}" >/dev/null 2>&1 &

for i in $(seq -w 1 "${FRAMES}"); do
  ./screenshot.sh "${OUT}/frame-${i}.png" >/dev/null 2>&1 || true
  sleep 1
done
wait || true

ls "${OUT}"
