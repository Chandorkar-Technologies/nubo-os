#!/usr/bin/env bash
# Build Nubo Office for iPhone and iPad on a Mac, following ios/README.md in Collabora's source, and upload it to App Store Connect.
#
# Usage: ci/build-office-ios.sh [STAGE ...]
#   stages (default: engine online app):
#     engine   cross-compile the office engine for iOS (arm64; hours, safe to re-run, make resumes)
#     online   configure the monorepo for the iOS app and build the web interface
#     app      archive with Xcode, export the .ipa
#     upload   validate and upload the .ipa with altool
# Environment: SRC (the rebranded checkout, default ~/nubo-build/ios/src), BUNDLE_ID (default tech.nubosuite.OfficeMobile),
#              TEAM (default 8DRPWCDRML), PROFILE (the App Store provisioning profile name, default "Nubo Office iOS App Store"),
#              VER (default 26.4.3), BUILD (App Store build number, default 1), ASC_KEY / ASC_ISSUER for the upload.
# Run ci/../office/rebrand.py --platform ios on the checkout first (the engine stage does it if needed).
# The app is built without the iCloud, custom-fonts and app-group capabilities of Collabora's app, and runs on a real device only
# (the engine is arm64 iOS, not the simulator).
set -euo pipefail
cd "$(dirname "$0")/.."
ROOT="$PWD"
SRC="${SRC:-$HOME/nubo-build/ios/src}"
BUNDLE_ID="${BUNDLE_ID:-tech.nubosuite.Office}"
TEAM="${TEAM:-8DRPWCDRML}"
PROFILE="${PROFILE:-Nubo Office iOS App Store (shared ID)}"; PROFILE_EXT="${PROFILE_EXT:-Nubo Office iOS QuickLook}"
VER="${VER:-26.4.3}"
BUILD="${BUILD:-1}"
OUT="${OUT:-$HOME/nubo-build/ios/out}"; LOGS="${LOGS:-$HOME/nubo-build/logs}"; mkdir -p "$OUT" "$LOGS"
export PATH="/opt/homebrew/opt/node@22/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/make/libexec/gnubin:$PATH"
stages=("$@"); [[ ${#stages[@]} -eq 0 ]] && stages=(engine online app)
has() { local s; for s in "${stages[@]}"; do [[ "$s" == "$1" ]] && return 0; done; return 1; }

if has engine; then
  echo "==> engine (iOS)"
  python3 "$ROOT/office/rebrand.py" "$SRC" --platform ios --bundle-id "$BUNDLE_ID" --team "$TEAM"
  # Xcode 27's C++ library refuses iOS 14.5 as the minimum: use the app's own (16.5)
  sed -i '' 's/-miphoneos-version-min=14.5/-miphoneos-version-min=16.5/' "$SRC/engine/configure.ac"
  cat > "$SRC/engine/autogen.input" <<INPUT
--with-distro=CPiOS
--enable-ccache
--without-lang
--with-product-name=Nubo Office
--with-vendor=Nubo
INPUT
  ( cd "$SRC/engine" && ./autogen.sh && caffeinate -dimsu make -j"$(sysctl -n hw.ncpu)" ) 2>&1 | tee -a "$LOGS/ios-engine.log" | tail -20
fi

if has online; then
  echo "==> online (iOS app configuration and web interface)"
  ( cd "$SRC" && ./autogen.sh && ./configure --enable-iosapp --with-app-name="Nubo Office" --enable-experimental \
      --with-vendor=Nubo --with-lo-builddir="$SRC/engine" && (cd browser && make) ) 2>&1 | tee -a "$LOGS/ios-online.log" | tail -20
fi

if has app; then
  echo "==> app (Xcode archive)"
  cd "$SRC/ios"
  python3 "$ROOT/office/rebrand.py" "$SRC" --platform ios --bundle-id "$BUNDLE_ID" --team "$TEAM"   # icon set, bundle IDs
  # one profile per target (the app and its QuickLook extension)
  python3 - "$SRC/ios/Mobile.xcodeproj/project.pbxproj" "$PROFILE" "$PROFILE_EXT" <<'PY'
import re, sys
p, app, ext = sys.argv[1:4]
t = open(p).read()
t = re.sub(r"\n\t*PROVISIONING_PROFILE_SPECIFIER = [^\n]*;", "", t)
def fix(m):
    b = m.group(0)
    if "INFOPLIST_FILE = FakeQuickLook/Info.plist;" in b: return b.replace("buildSettings = {", 'buildSettings = {\n\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "%s";' % ext, 1)
    if "INFOPLIST_FILE = Mobile/Info.plist;" in b: return b.replace("buildSettings = {", 'buildSettings = {\n\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "%s";' % app, 1)
    return b
t = re.sub(r"buildSettings = \{.*?\n\t\t\t\};", fix, t, flags=re.S)
open(p, "w").write(t)
PY
  rm -rf "$OUT/Mobile.xcarchive"
  xcodebuild archive -project Mobile.xcodeproj -scheme Mobile -configuration Release -destination 'generic/platform=iOS' \
    -archivePath "$OUT/Mobile.xcarchive" \
    DEVELOPMENT_TEAM="$TEAM" CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY="Apple Distribution" \
    MARKETING_VERSION="$VER" CURRENT_PROJECT_VERSION="$BUILD" 2>&1 | tee -a "$LOGS/ios-app.log" | tail -30
  cat > "$OUT/ExportOptions.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>method</key><string>app-store-connect</string>
  <key>teamID</key><string>$TEAM</string>
  <key>signingStyle</key><string>manual</string>
  <key>signingCertificate</key><string>Apple Distribution</string>
  <key>provisioningProfiles</key><dict><key>$BUNDLE_ID</key><string>$PROFILE</string><key>$BUNDLE_ID.FakeQuickLook</key><string>$PROFILE_EXT</string></dict>
  <key>uploadSymbols</key><true/>
</dict></plist>
PLIST
  rm -rf "$OUT/ipa"; xcodebuild -exportArchive -archivePath "$OUT/Mobile.xcarchive" -exportOptionsPlist "$OUT/ExportOptions.plist" -exportPath "$OUT/ipa" 2>&1 | tail -15
  ls -la "$OUT/ipa"
fi

if has upload; then
  IPA="$(ls "$OUT"/ipa/*.ipa | head -1)"
  xcrun altool --validate-app -f "$IPA" -t ios --apiKey "${ASC_KEY:-K3VJA2J6U8}" --apiIssuer "${ASC_ISSUER:?}"
  xcrun altool --upload-app -f "$IPA" -t ios --apiKey "${ASC_KEY:-K3VJA2J6U8}" --apiIssuer "${ASC_ISSUER:?}"
fi
