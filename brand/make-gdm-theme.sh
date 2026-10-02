#!/usr/bin/env bash
# Pack the Nubo shell theme into the resource bundle the login screen loads.
#
# The login screen does not read themes from /usr/share/themes; it loads one
# bundle chosen through the gdm-theme.gresource alternative. Different GNOME
# and Ubuntu versions ask that bundle for different stylesheet names, so the
# same stylesheet is provided under each of them.
#
# Usage: make-gdm-theme.sh SHELL_THEME_DIR OUTPUT.gresource [BACKGROUND_IMAGE]
# The optional image becomes the login screen background (softly blurred and
# slightly dimmed so the login box stays readable, without losing the colours).

set -euo pipefail

SRC="${1:?shell theme directory required}"
OUT="${2:?output file required}"
BG="${3:-}"

WORK="$(mktemp -d)"
trap 'rm -rf "${WORK}"' EXIT

cp -r "${SRC}/." "${WORK}/"

CSS_NAMES=(
  gdm.css
  gnome-shell-dark.css
  gnome-shell-light.css
  gnome-shell-high-contrast.css
  Yaru/gnome-shell.css
  Yaru/gnome-shell-dark.css
  Yaru/gnome-shell-high-contrast.css
)

for name in "${CSS_NAMES[@]}"; do
  mkdir -p "${WORK}/$(dirname "${name}")"
  cp "${SRC}/gnome-shell.css" "${WORK}/${name}"
done
# Stylesheets in the subfolder refer to assets relative to themselves.
cp -r "${SRC}/assets" "${WORK}/Yaru/assets"

if [[ -n "${BG}" ]]; then
  magick=$(command -v magick || command -v convert)
  "${magick}" "${BG}" -resize 2560x -blur 0x6 -brightness-contrast -8x0 -quality 88 "${WORK}/nubo-login.jpg"
  find "${WORK}" -name '*.css' -exec sed -i '/^#lockDialogGroup {/,/^}/ s|background-color: #000000;|background-color: #0a0a0c;\n  background-image: url("resource:///org/gnome/shell/theme/nubo-login.jpg");\n  background-size: cover;\n  background-position: center;|' {} +
fi

{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<gresources>'
  echo '  <gresource prefix="/org/gnome/shell/theme">'
  (cd "${WORK}" && find . -type f ! -name '*.gresource.xml' | sed 's|^\./||' | sort) \
    | while IFS= read -r file; do
        echo "    <file>${file}</file>"
      done
  echo '  </gresource>'
  echo '</gresources>'
} >"${WORK}/nubo.gresource.xml"

mkdir -p "$(dirname "${OUT}")"
glib-compile-resources --sourcedir="${WORK}" --target="${OUT}" "${WORK}/nubo.gresource.xml"
echo "wrote ${OUT}"
