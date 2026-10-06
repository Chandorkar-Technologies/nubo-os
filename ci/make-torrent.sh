#!/usr/bin/env bash
# Make a .torrent for one release file. The torrent lists our download address as
# a web seed, so it works even when no other peer is online, and public trackers
# so peers can find each other.
# Usage: make-torrent.sh FILE VERSION   (writes FILE.torrent next to it)
set -euo pipefail
FILE="$(readlink -f "${1:?file}")"; VER="${2:?version}"
BASE="${DL_BASE:-https://archive.nubosuite.tech/dl}"
TRACKERS=(
  udp://tracker.opentrackr.org:1337/announce
  udp://open.stealth.si:80/announce
  udp://tracker.torrent.eu.org:451/announce
  udp://exodus.desync.com:6969/announce
  https://tracker.gbitt.info:443/announce
)
args=(); for t in "${TRACKERS[@]}"; do args+=(-a "${t}"); done
rm -f "${FILE}.torrent"
# 4 MiB pieces keep the torrent small for multi-gigabyte files.
mktorrent -l 22 -c "Nubo OS ${VER}" "${args[@]}" \
  -w "${BASE}/${VER}/$(basename "${FILE}")" \
  -o "${FILE}.torrent" "${FILE}" >/dev/null
echo "torrent: $(basename "${FILE}").torrent"
