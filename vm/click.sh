#!/usr/bin/env bash
# Click at a screen position in a VM, then capture its screen.
# Coordinates are pixels in a full-size screenshot of that VM.
# Usage: vm/click.sh VMID OUTPUT.png X Y [WAIT_SECONDS]

set -euo pipefail

VMID="${1:?VM id required}"
OUT="${2:?output file required}"
X="${3:?x required}"
Y="${4:?y required}"
WAIT="${5:-3}"
# Local settings (Proxmox host etc.) can live outside the repository.
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env" ]] && . "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env"
PVE_HOST="${PVE_HOST:?set PVE_HOST to the Proxmox host, e.g. root@proxmox.example.net}"
SCREEN_W="${SCREEN_W:-1280}"
SCREEN_H="${SCREEN_H:-800}"

# Resolve before changing directory, so relative paths mean what the caller meant.
case "${OUT}" in /*) ;; *) OUT="${PWD}/${OUT}" ;; esac
cd "$(dirname "$0")"

# The VM's pointer is an absolute tablet addressed on a 0..32767 grid, which
# only the machine-protocol socket can drive.
ssh -o BatchMode=yes "${PVE_HOST}" python3 - "${VMID}" "${X}" "${Y}" "${SCREEN_W}" "${SCREEN_H}" <<'PYEOF'
import json, socket, sys, time

vmid, x, y, w, h = sys.argv[1], *map(int, sys.argv[2:6])
s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
s.connect(f"/var/run/qemu-server/{vmid}.qmp")
f = s.makefile("rw")

def call(cmd, **args):
    msg = {"execute": cmd}
    if args:
        msg["arguments"] = args
    f.write(json.dumps(msg) + "\n")
    f.flush()
    while True:
        reply = json.loads(f.readline())
        if "return" in reply or "error" in reply:
            return reply

f.readline()
call("qmp_capabilities")
ax = int(x * 32767 / w)
ay = int(y * 32767 / h)
move = [{"type": "abs", "data": {"axis": "x", "value": ax}},
        {"type": "abs", "data": {"axis": "y", "value": ay}}]
call("input-send-event", events=move)
time.sleep(0.2)
for down in (True, False):
    call("input-send-event",
         events=[{"type": "btn", "data": {"down": down, "button": "left"}}])
    time.sleep(0.15)
s.close()
PYEOF

sleep "${WAIT}"
VMID="${VMID}" ./screenshot.sh "${OUT}" >/dev/null
if command -v magick >/dev/null 2>&1; then
  magick "${OUT}" -resize 640x "${OUT%.png}-small.png"
fi
echo "${OUT}"
