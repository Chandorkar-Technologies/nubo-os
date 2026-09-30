#!/usr/bin/env bash
# Capture the dev VM's screen to a PNG on this machine.
# Works at any stage (boot screen, login, desktop) because it reads the VM's
# display from the hypervisor, not from inside the guest.
# Usage: vm/screenshot.sh OUTPUT.png

set -euo pipefail

OUT="${1:?output file required}"
# Local settings (Proxmox host etc.) can live outside the repository.
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env" ]] && . "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env"
PVE_HOST="${PVE_HOST:?set PVE_HOST to the Proxmox host, e.g. root@proxmox.example.net}"
VMID="${VMID:-301}"

if command -v magick >/dev/null 2>&1; then IM=(magick); else IM=(convert); fi

tmp="$(mktemp -t nubo-shot).ppm"
trap 'rm -f "${tmp}"' EXIT

ssh -o BatchMode=yes "${PVE_HOST}" "
  set -e
  f=/tmp/nubo-shot-${VMID}.ppm
  pvesh create /nodes/\$(hostname)/qemu/${VMID}/monitor --command \"screendump \$f\" >/dev/null
  cat \$f
  rm -f \$f
" >"${tmp}"

mkdir -p "$(dirname "${OUT}")"
"${IM[@]}" "${tmp}" "${OUT}"
echo "saved ${OUT}"
