#!/usr/bin/env bash
# Render the same set of icons from several icon themes into one comparison
# sheet, so packs can be judged side by side without installing every app.
# Run on Linux with the themes installed under /usr/share/icons.
# Usage: icon-compare.sh OUTPUT.png THEME [THEME...]

set -euo pipefail

OUT="${1:?output file required}"
shift
THEMES=("$@")

ICONS=(
  folder user-home user-trash
  org.gnome.Nautilus org.gnome.Settings org.gnome.Software
  org.gnome.Terminal org.gnome.TextEditor org.gnome.Calculator
  firefox thunderbird libreoffice-writer libreoffice-calc
  vlc code gimp org.gnome.Calendar help-browser
)

CELL=96
WORK="$(mktemp -d)"
trap 'rm -rf "${WORK}"' EXIT

# Themes fall back to the ones they inherit from, as the desktop does.
inherits_of() {
  sed -n 's/^Inherits=//p' "/usr/share/icons/$1/index.theme" 2>/dev/null | head -1 | tr ',' ' '
}

find_icon() {
  local theme="$1" name="$2" depth="${3:-0}" hit parent
  [[ "${depth}" -gt 4 ]] && return 1
  hit="$(find -L "/usr/share/icons/${theme}" \
    \( -name "${name}.svg" -o -name "${name}.png" \) \
    -not -path '*symbolic*' -not -path '*/16*' -not -path '*/22*' -not -path '*/24*' \
    2>/dev/null | sort -r | head -1)"
  if [[ -n "${hit}" ]]; then
    echo "${hit}"
    return 0
  fi
  for parent in $(inherits_of "${theme}"); do
    [[ "${parent}" == "hicolor" ]] && continue
    find_icon "${parent}" "${name}" $((depth + 1)) && return 0
  done
  return 1
}

rows=()
for theme in "${THEMES[@]}"; do
  cells=()
  for name in "${ICONS[@]}"; do
    cell="${WORK}/${theme}-${name}.png"
    if src="$(find_icon "${theme}" "${name}")"; then
      case "${src}" in
        *.svg) rsvg-convert -w "${CELL}" -h "${CELL}" -a "${src}" -o "${cell}" 2>/dev/null \
                 || convert -size "${CELL}x${CELL}" xc:none "${cell}" ;;
        *)     convert "${src}" -resize "${CELL}x${CELL}" "${cell}" ;;
      esac
    else
      convert -size "${CELL}x${CELL}" xc:none "${cell}"
    fi
    cells+=("${cell}")
  done
  row="${WORK}/row-${theme}.png"
  montage "${cells[@]}" -tile "${#cells[@]}x1" -geometry "${CELL}x${CELL}+12+12" \
    -background '#1a1a1a' "${WORK}/strip.png"
  convert -background '#1a1a1a' -fill white -font DejaVu-Sans-Bold -pointsize 22 \
    -size "300x$((CELL + 24))" -gravity west "caption:  ${theme}" "${WORK}/label.png"
  convert "${WORK}/label.png" "${WORK}/strip.png" +append "${row}"
  rows+=("${row}")
done

convert "${rows[@]}" -append "${OUT}"
echo "wrote ${OUT}"
