#!/usr/bin/env bash
# Hide launcher entries listed in data/apps/hide.list: write an override copy
# of each original with NoDisplay=true. Ids that are not installed are skipped.
# Usage: make-hidden-entries.sh LIST OUTPUT_DIR
set -euo pipefail
LIST="${1:?list required}"; OUT="${2:?output required}"
mkdir -p "${OUT}"
n=0
while read -r id; do
  [[ -z "${id}" || "${id}" == \#* ]] && continue
  src="/usr/share/applications/${id}.desktop"
  [[ -f "${src}" ]] || continue
  grep -v -E '^(NoDisplay|Hidden)=' "${src}" \
    | sed '0,/^\[Desktop Entry\]/s//[Desktop Entry]\nNoDisplay=true/' > "${OUT}/${id}.desktop"
  n=$((n + 1))
done < "${LIST}"
echo "hidden entries: ${n}"
