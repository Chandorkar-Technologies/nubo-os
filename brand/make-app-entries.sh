#!/usr/bin/env bash
# Generate renamed desktop entries for first-party apps from data/apps/rebrand.list.
# Reads the originals from /usr/share/applications (or their diverted .ubuntu
# copies) and writes overrides to OUTPUT_DIR.
# Usage: make-app-entries.sh LIST OUTPUT_DIR
set -euo pipefail
LIST="${1:?list required}"; OUT="${2:?output required}"
mkdir -p "${OUT}"
while IFS='|' read -r id name comment icon; do
  [[ -z "${id}" || "${id}" == \#* ]] && continue
  src="/usr/share/applications/${id}.desktop"
  [[ -f "${src}" ]] || { echo "skip ${id}: not installed" >&2; continue; }
  grep -v -E '^(Name|Comment|GenericName)(\[[^]]*\])?=' "${src}" \
    | sed "0,/^\[Desktop Entry\]/s//[Desktop Entry]\nName=${name}\nComment=${comment}/" \
    > "${OUT}/${id}.desktop"
  # Optional fourth field: a different icon name.
  if [[ -n "${icon:-}" ]]; then
    sed -i.bak "s|^Icon=.*|Icon=${icon}|" "${OUT}/${id}.desktop" && rm -f "${OUT}/${id}.desktop.bak"
  fi
done < "${LIST}"
echo "app entries: $(ls "${OUT}" | wc -l)"
