#!/usr/bin/env bash
# Repack the Tauri build of Nubo Mail (repo Chandorkar-Technologies/nubo-v2) as
# the nubo-mail package: right package name, "Nubo Mail" in menus and the dock.
# Usage: mail/repack.sh Nubo_0.1.0_amd64.deb out/
set -euo pipefail
SRC="$(readlink -f "${1:?tauri .deb required}")"
OUT="$(readlink -f "${2:?output directory required}")"
T="$(mktemp -d)"
trap 'rm -rf "${T}"' EXIT
dpkg-deb -R "${SRC}" "${T}/pkg"
sed -i -e 's/^Package: .*/Package: nubo-mail/' \
       -e 's/^Maintainer: .*/Maintainer: Nubo <hello@nubosuite.tech>/' "${T}/pkg/DEBIAN/control"
grep -q '^Description:' "${T}/pkg/DEBIAN/control" || echo 'Description: Nubo Mail' >>"${T}/pkg/DEBIAN/control"
D="${T}/pkg/usr/share/applications"
mv "${D}/Nubo.desktop" "${D}/nubo-mail.desktop"
cat >"${D}/nubo-mail.desktop" <<'DESKTOP'
[Desktop Entry]
Type=Application
Name=Nubo Mail
Comment=Mail, calendar and contacts
Exec=nubo
Icon=nubo
StartupWMClass=nubo
Categories=Network;Email;
Terminal=false
DESKTOP
mkdir -p "${OUT}"
dpkg-deb --build --root-owner-group "${T}/pkg" "${OUT}/nubo-mail_$(dpkg-deb -f "${SRC}" Version)_amd64.deb"
