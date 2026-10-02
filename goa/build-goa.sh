#!/usr/bin/env bash
#
# Build Ubuntu's gnome-online-accounts with the Nubo provider patch.
#
# Run on the Nubo OS / Ubuntu machine as the NORMAL user (it uses sudo only for
# apt-get build-dep and, once, to enable deb-src). Results:
#
#   $OUT/*.deb       binary packages, version <ubuntu version>+nubo1
#
# Environment overrides:
#   WORK    scratch directory            (default: ~/goa-nubo-build)
#   OUT     where the .debs are left     (default: <this dir>/out)
#   PATCH   patch to apply               (default: <this dir>/patches/nubo-provider.patch)
#   SUFFIX  version suffix               (default: +nubo1)
#   JOBS    parallel jobs                (default: nproc)
#   SKIP_BUILD_DEP=1   do not run apt-get build-dep
#   DEB_BUILD_OPTIONS  passed through (e.g. "nocheck")
#
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="${WORK:-$HOME/goa-nubo-build}"
OUT="${OUT:-$HERE/out}"
PATCH="${PATCH:-$HERE/patches/nubo-provider.patch}"
SUFFIX="${SUFFIX:-+nubo1}"
JOBS="${JOBS:-$(nproc)}"

if [ "$(id -u)" -eq 0 ]; then
    echo "Run this as a normal user, not root." >&2
    exit 1
fi
[ -f "$PATCH" ] || { echo "Patch not found: $PATCH" >&2; exit 1; }

# 1. Source repositories ------------------------------------------------------
if ! apt-get source --print-uris gnome-online-accounts >/dev/null 2>&1; then
    echo "==> Enabling deb-src in /etc/apt/sources.list.d/ubuntu.sources"
    sudo sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/ubuntu.sources
    sudo apt-get update
fi

# 2. Build dependencies -------------------------------------------------------
if [ -z "${SKIP_BUILD_DEP:-}" ]; then
    echo "==> Installing build dependencies"
    sudo apt-get build-dep -y gnome-online-accounts
    sudo apt-get install -y devscripts dpkg-dev
fi

# 3. Fetch the source package -------------------------------------------------
echo "==> Fetching source in $WORK"
rm -rf "$WORK"
mkdir -p "$WORK" "$OUT"
cd "$WORK"
apt-get source gnome-online-accounts
SRC="$(find . -maxdepth 1 -type d -name 'gnome-online-accounts-*' | head -n1)"
cd "$SRC"

UPSTREAM_VERSION="$(dpkg-parsechangelog -S Version)"
case "$UPSTREAM_VERSION" in
    *"$SUFFIX") echo "Source is already $UPSTREAM_VERSION" >&2; exit 1 ;;
esac
NEW_VERSION="${UPSTREAM_VERSION}${SUFFIX}"
echo "==> Ubuntu version $UPSTREAM_VERSION -> $NEW_VERSION"

# 4. Apply the patch as a quilt patch ----------------------------------------
echo "==> Checking that the patch applies"
if ! patch -p1 --dry-run --silent < "$PATCH"; then
    echo "The Nubo patch does not apply to $UPSTREAM_VERSION." >&2
    echo "Rebase $PATCH on this source (see README.md) and retry." >&2
    exit 1
fi
cp "$PATCH" debian/patches/nubo-provider.patch
# Make sure series ends with a newline before appending
[ -s debian/patches/series ] && [ -n "$(tail -c1 debian/patches/series)" ] && echo >> debian/patches/series
echo "nubo-provider.patch" >> debian/patches/series

# 5. Version, changelog -------------------------------------------------------
DEBFULLNAME="${DEBFULLNAME:-Nubo}" DEBEMAIL="${DEBEMAIL:-packages@nubo.email}" \
    dch --force-bad-version --newversion "$NEW_VERSION" \
        --distribution "$(dpkg-parsechangelog -S Distribution)" \
        "Add the Nubo account provider (mail, calendar, contacts and files from one host)."

# 6. Build --------------------------------------------------------------------
echo "==> Building"
dpkg-buildpackage -us -uc -b "-j$JOBS"

cd "$WORK"
cp -v ./*.deb "$OUT"/
echo
echo "Done. Packages in $OUT:"
ls -1 "$OUT"/*.deb
