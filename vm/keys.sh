#!/usr/bin/env bash
# Press keys in a VM, then capture its screen. For driving installers and
# other screens that cannot be reached over the network.
# Usage: vm/keys.sh VMID OUTPUT.png KEY [KEY...]
#
# Keys use QEMU names: ret, tab, esc, spc, up, down, shift-tab, alt-n, a, 1 ...
# A key of the form text:hello types the letters one by one.
# A key of the form wait:5 pauses for that many seconds.

set -euo pipefail

VMID="${1:?VM id required}"
OUT="${2:?output file required}"
shift 2
# Local settings (Proxmox host etc.) can live outside the repository.
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env" ]] && . "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env"
PVE_HOST="${PVE_HOST:?set PVE_HOST to the Proxmox host, e.g. root@proxmox.example.net}"

# Resolve before changing directory, so relative paths mean what the caller meant.
case "${OUT}" in /*) ;; *) OUT="${PWD}/${OUT}" ;; esac
cd "$(dirname "$0")"

qemu_key() {
  case "$1" in
    ' ') echo spc ;;
    '-') echo minus ;;
    '=') echo equal ;;
    '.') echo dot ;;
    ',') echo comma ;;
    '/') echo slash ;;
    ';') echo semicolon ;;
    "'") echo apostrophe ;;
    '[') echo bracket_left ;;
    ']') echo bracket_right ;;
    '\\') echo backslash ;;
    '`') echo grave_accent ;;
    '!') echo shift-1 ;;
    '@') echo shift-2 ;;
    '#') echo shift-3 ;;
    '$') echo shift-4 ;;
    '%') echo shift-5 ;;
    '^') echo shift-6 ;;
    '&') echo shift-7 ;;
    '*') echo shift-8 ;;
    '(') echo shift-9 ;;
    ')') echo shift-0 ;;
    '_') echo shift-minus ;;
    '+') echo shift-equal ;;
    ':') echo shift-semicolon ;;
    '"') echo shift-apostrophe ;;
    '<') echo shift-comma ;;
    '>') echo shift-dot ;;
    '?') echo shift-slash ;;
    '|') echo shift-backslash ;;
    '~') echo shift-grave_accent ;;
    # [[:upper:]], not [A-Z]: the range form matches lowercase in some locales.
    [[:upper:]]) echo "shift-$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" ;;
    *) echo "$1" ;;
  esac
}

commands=""
for key in "$@"; do
  case "${key}" in
    wait:*) commands+="sleep ${key#wait:}; " ;;
    text:*)
      text="${key#text:}"
      for ((i = 0; i < ${#text}; i++)); do
        commands+="qm sendkey ${VMID} $(qemu_key "${text:i:1}"); sleep 0.15; "
      done
      ;;
    *) commands+="qm sendkey ${VMID} ${key}; sleep 0.4; " ;;
  esac
done

ssh -o BatchMode=yes "${PVE_HOST}" "${commands} sleep 2"
VMID="${VMID}" ./screenshot.sh "${OUT}" >/dev/null

if command -v magick >/dev/null 2>&1; then
  magick "${OUT}" -resize 900x "${OUT%.png}-small.png"
fi
echo "${OUT}"
