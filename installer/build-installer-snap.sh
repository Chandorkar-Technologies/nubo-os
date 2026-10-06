#!/usr/bin/env bash
# Rebuild the installer app so it calls the product "Nubo OS" instead of
# "Ubuntu", then repack the installer snap with the rebuilt app inside.
#
# The name comes from a fixed list compiled into the app (the ubuntu_flavor
# package), so nothing short of a rebuild changes "Welcome to Ubuntu" and
# "Install Ubuntu". Everything else in the snap (installer backend, tools)
# stays as shipped on the Ubuntu media.
#
# Sources and toolchain are pinned to what the shipped snap was built from
# (see the snap recipe at tag ubuntu-desktop-bootstrap/26.04.1).
#
# Run on Linux with network access. Takes 15-30 minutes the first time.
# Usage: build-installer-snap.sh ORIGINAL.snap OUTPUT.snap

set -euo pipefail

ORIG_SNAP="$(readlink -f "${1:?original snap required}")"
OUT_SNAP="$(readlink -f "${2:?output snap path required}")"
WORK="${WORK:-$HOME/build/installer}"

APP_REPO=https://github.com/canonical/ubuntu-desktop-provision
APP_COMMIT=6623407beba8f4d8cb0f331a232d0a7d271a9f7a
FLUTTER_VERSION=3.44.1
FLAVOR_PKG=ubuntu_flavor-0.5.0+1
PRODUCT_NAME="Nubo OS"

mkdir -p "${WORK}"
cd "${WORK}"

if [[ ! -x flutter/bin/flutter ]]; then
  git clone -q -b "${FLUTTER_VERSION}" --depth 1 https://github.com/flutter/flutter.git
fi
export PATH="${WORK}/flutter/bin:${HOME}/.pub-cache/bin:${PATH}"
flutter config --no-analytics >/dev/null
flutter --version | head -1

if [[ ! -d src/.git ]]; then
  git clone -q "${APP_REPO}" src
fi
cd src
git fetch -q origin "${APP_COMMIT}"
git checkout -q "${APP_COMMIT}"

echo "==> Resolving packages"
dart pub global activate melos >/dev/null
dart pub global run melos bootstrap >/dev/null

echo "==> Renaming the product"
flavor_dir="$(ls -d "${HOME}"/.pub-cache/hosted/pub.dev/"${FLAVOR_PKG}")"
sed -i "s/^  ubuntu('Ubuntu'),/  ubuntu('${PRODUCT_NAME}'),/" "${flavor_dir}/lib/src/ubuntu_flavor.dart"
grep -q "ubuntu('${PRODUCT_NAME}')" "${flavor_dir}/lib/src/ubuntu_flavor.dart"

echo "==> Building the app"
cd apps/ubuntu_bootstrap
# Texts that name the product without going through the flavour: the window
# title (every language), and the English strings that still say Ubuntu.
sed -i -E 's/^(  "appTitle": ).*/\1"Nubo OS Installer",/' lib/l10n/*.arb
# Only the text after the key: the key itself (notEnoughDiskSpaceUbuntu) must stay a valid name.
sed -i -E '/^  "(landscapeConfirmPageSuccessInfoTitle|notEnoughDiskSpaceUbuntu)":/ s/(": ".*)Ubuntu/\1Nubo OS/' lib/l10n/ubuntu_bootstrap_en.arb
flutter gen-l10n >/dev/null
flutter build linux --release >/dev/null
bundle="$(readlink -f "$(ls -d build/linux/*/release/bundle)")"
# (grep -q on a pipe would stop strings early and trip pipefail.)
grep -q "${PRODUCT_NAME}" <(strings "${bundle}/lib/libapp.so")
if strings "${bundle}/lib/libapp.so" | grep -q "Ubuntu Desktop Installer"; then echo "Installer still carries the Ubuntu window title." >&2; exit 1; fi

echo "==> Repacking the snap"
cd "${WORK}"
rm -rf snapdir
unsquashfs -q -d snapdir "${ORIG_SNAP}"
rm -rf snapdir/bin/ubuntu_bootstrap snapdir/bin/lib snapdir/bin/data
cp -r "${bundle}"/. snapdir/bin/
rm -f "${OUT_SNAP}"
mksquashfs snapdir "${OUT_SNAP}" -noappend -comp xz -no-xattrs -no-fragments -all-root -quiet -no-progress
ls -lh "${OUT_SNAP}"
echo "==> Done"
