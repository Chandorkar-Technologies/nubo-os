#!/usr/bin/env bash
# Build the Nubo icon themes as a thin layer over Papirus.
#
# Papirus itself comes from the Ubuntu archive and keeps updating on its own.
# This layer only changes two things: folders become grey, and distributor
# logos become the Nubo mark. Every other icon is inherited.
#
# Usage: make-icon-overlay.sh OUTPUT_DIR LOGO_DIR

set -euo pipefail

OUT="${1:?output directory required}"
LOGOS="${2:?logo directory required}"
PAPIRUS="${PAPIRUS:-/usr/share/icons/Papirus}"
FROM_COLOUR="blue"
TO_COLOUR="grey"

if [[ ! -d "${PAPIRUS}" ]]; then
  echo "Papirus not found at ${PAPIRUS}; install papirus-icon-theme." >&2
  exit 1
fi

# Logo names the desktop looks up. The app-grid name carries the session mode,
# which is "ubuntu" on Ubuntu Desktop.
LOGO_NAMES=(start-here distributor-logo ubuntu-logo ubuntu-logo-icon gnome-initial-setup org.gnome.InitialSetup)
SYMBOLIC_NAMES=(start-here-symbolic view-app-grid-ubuntu-symbolic)

# build NAME PARENT MARK_FILE
build() {
  local name="$1" parent="$2" mark="$3"
  local dest="${OUT}/${name}"
  local dirs=() sections=""

  rm -rf "${dest}"
  mkdir -p "${dest}"

  local places size scale px entry target grey count=0
  for places in "${PAPIRUS}"/*/places; do
    size="$(basename "$(dirname "${places}")")"
    mkdir -p "${dest}/${size}/places"

    for entry in "${places}"/*; do
      [[ -L "${entry}" ]] || continue
      target="$(basename "$(readlink -f "${entry}")")"
      [[ "${target}" == *"-${FROM_COLOUR}"* ]] || continue
      grey="${places}/${target//-${FROM_COLOUR}/-${TO_COLOUR}}"
      [[ -e "${grey}" ]] || continue
      ln -s "${grey}" "${dest}/${size}/places/$(basename "${entry}")"
      count=$((count + 1))
    done

    px="${size%%x*}"
    scale=1
    [[ "${size}" == *@2x ]] && scale=2
    dirs+=("${size}/places")
    sections+=$'\n'"[${size}/places]"$'\n'"Size=${px}"$'\n'"Scale=${scale}"$'\n'"Context=Places"$'\n'"Type=Fixed"$'\n'
  done

  mkdir -p "${dest}/scalable/places" "${dest}/scalable/actions"
  local logo
  for logo in "${LOGO_NAMES[@]}"; do
    cp "${mark}" "${dest}/scalable/places/${logo}.svg"
  done
  # The first-run welcome screen asks for Ubuntu's mascot by these names;
  # each name is drawn on the background its name says.
  cp "${LOGOS}/nubo-mark-black.svg" "${dest}/scalable/places/ubuntu-mascot-light.svg"
  cp "${LOGOS}/nubo-mark-white.svg" "${dest}/scalable/places/ubuntu-mascot-dark.svg"
  for logo in "${SYMBOLIC_NAMES[@]}"; do
    cp "${mark}" "${dest}/scalable/actions/${logo}.svg"
  done
  dirs+=("scalable/places" "scalable/actions")
  sections+=$'\n'"[scalable/places]"$'\n'"Size=64"$'\n'"MinSize=8"$'\n'"MaxSize=512"$'\n'"Context=Places"$'\n'"Type=Scalable"$'\n'
  sections+=$'\n'"[scalable/actions]"$'\n'"Size=16"$'\n'"MinSize=8"$'\n'"MaxSize=512"$'\n'"Context=Actions"$'\n'"Type=Scalable"$'\n'

  {
    echo "[Icon Theme]"
    echo "Name=${name}"
    echo "Comment=Nubo OS icons"
    echo "Inherits=${parent},hicolor"
    echo "Example=folder"
    local IFS=,
    echo "Directories=${dirs[*]}"
    echo "${sections}"
  } >"${dest}/index.theme"

  echo "${name}: ${count} folder icons relinked, inherits ${parent}"
}

build Nubo      Papirus      "${LOGOS}/nubo-mark-black.svg"
build Nubo-Dark Papirus-Dark "${LOGOS}/nubo-mark-white.svg"
