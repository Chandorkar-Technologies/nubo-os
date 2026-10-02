#!/usr/bin/env bash
#
# OPTIONAL: build Ubuntu's gnome-control-center with "Nubo" sorted first in
# Settings > Online Accounts.
#
# Why: gnome-control-center does not use the order of goa_provider_get_all().
# panels/online-accounts/cc-online-accounts-panel.c sorts providers with a
# hard-coded priority list and puts every provider it does not know last, so
# without this patch "Nubo" appears at the bottom of the list.
#
# Run as the normal user on the Nubo OS / Ubuntu machine. It builds the .debs but
# does NOT install them. Needs the Nubo libgoa-*-dev packages (from build-goa.sh)
# installed, because Ubuntu's build dependencies require libgoa-1.0-dev (= the
# libgoa-1.0-0b version that is installed).
#
# Environment: WORK, OUT, PATCH, SUFFIX, JOBS, SKIP_BUILD_DEP (as build-goa.sh).
#
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="${WORK:-$HOME/gcc-nubo-build}"
OUT="${OUT:-$HERE/out-control-center}"
PATCH="${PATCH:-$HERE/patches/gnome-control-center-nubo-first.patch}"
SUFFIX="${SUFFIX:-+nubo1}"
JOBS="${JOBS:-$(nproc)}"

[ "$(id -u)" -ne 0 ] || { echo "Run this as a normal user, not root." >&2; exit 1; }
[ -f "$PATCH" ] || { echo "Patch not found: $PATCH" >&2; exit 1; }

if ! apt-get source --print-uris gnome-control-center >/dev/null 2>&1; then
    sudo sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/ubuntu.sources
    sudo apt-get update
fi

if [ -z "${SKIP_BUILD_DEP:-}" ]; then
    sudo apt-get build-dep -y gnome-control-center
    sudo apt-get install -y devscripts dpkg-dev
fi

rm -rf "$WORK"
mkdir -p "$WORK" "$OUT"
cd "$WORK"
apt-get source gnome-control-center
cd "$(find . -maxdepth 1 -type d -name 'gnome-control-center-*' | head -n1)"

OLD="$(dpkg-parsechangelog -S Version)"
NEW="${OLD}${SUFFIX}"

if ! patch -p1 --dry-run --silent < "$PATCH"; then
    echo "The patch does not apply to $OLD; edit goa_priority[] in" >&2
    echo "panels/online-accounts/cc-online-accounts-panel.c by hand and re-diff." >&2
    exit 1
fi
cp "$PATCH" debian/patches/nubo-online-accounts-first.patch
[ -s debian/patches/series ] && [ -n "$(tail -c1 debian/patches/series)" ] && echo >> debian/patches/series
echo "nubo-online-accounts-first.patch" >> debian/patches/series

DEBFULLNAME="${DEBFULLNAME:-Nubo}" DEBEMAIL="${DEBEMAIL:-packages@nubo.email}" \
    dch --force-bad-version --newversion "$NEW" \
        --distribution "$(dpkg-parsechangelog -S Distribution)" \
        "List the Nubo account provider first in Online Accounts."

dpkg-buildpackage -us -uc -b "-j$JOBS"

cd "$WORK"
cp -v ./*.deb "$OUT"/
echo "Done. Packages in $OUT (not installed)."
