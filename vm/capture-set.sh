#!/usr/bin/env bash
# Capture the standard review set of screenshots from the dev VM.
# Opens each surface inside the logged-in desktop session, captures it from
# the hypervisor, then closes it again.
# Usage: vm/capture-set.sh OUTPUT_DIR [PREFIX]

set -euo pipefail

OUT="${1:?output directory required}"
PREFIX="${2:-}"
# Local settings (Proxmox host etc.) can live outside the repository.
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env" ]] && . "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env"
PVE_HOST="${PVE_HOST:?set PVE_HOST to the Proxmox host, e.g. root@proxmox.example.net}"
VM_USER="${VM_USER:-nubo}"
VMID="${VMID:-301}"

# Resolve before changing directory, so relative paths mean what the caller meant.
case "${OUT}" in /*) ;; *) OUT="${PWD}/${OUT}" ;; esac
cd "$(dirname "$0")"

pve() { ssh -o BatchMode=yes "${PVE_HOST}" "$@"; }

VM_IP="${VM_IP:-$(pve "qm guest cmd ${VMID} network-get-interfaces" \
  | grep -o '"ip-address" : "10\.[0-9.]*"' | head -1 | cut -d'"' -f4)}"

# Run a command inside the user's graphical session.
in_session() {
  ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -J "${PVE_HOST}" "${VM_USER}@${VM_IP}" \
    "export XDG_RUNTIME_DIR=/run/user/\$(id -u) WAYLAND_DISPLAY=wayland-0 \
       XDG_CURRENT_DESKTOP=ubuntu:GNOME XDG_SESSION_TYPE=wayland \
       DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/\$(id -u)/bus; $*"
}

key()  { pve "qm sendkey ${VMID} $1"; }
shot() { ./screenshot.sh "${OUT}/${PREFIX}$1.png"; }

mkdir -p "${OUT}"

key esc; sleep 1
shot 01-desktop

in_session '(setsid nautilus --new-window >/dev/null 2>&1 &); sleep 6'
shot 02-files
in_session 'pkill -x nautilus || true' || true

in_session '(setsid gnome-control-center appearance >/dev/null 2>&1 &); sleep 7'
shot 03-settings
# Match on the process name: `pkill -f` would also match this very command.
in_session 'pkill -x gnome-control-c || true' || true; sleep 1

key meta_l-s; sleep 3
shot 04-quick-settings
key esc; sleep 1

key meta_l-v; sleep 3
shot 05-notifications
key esc; sleep 1

key meta_l; sleep 3
shot 06-overview
key esc; sleep 1

key meta_l-a; sleep 3
shot 07-app-grid
key esc; sleep 1; key esc
