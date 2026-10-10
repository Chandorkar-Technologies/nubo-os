#!/usr/bin/env bash
# Build Nubo Office for Android (arm64-v8a) on the Linux build server, following android/README.md in Collabora's source.
#
# Usage: ci/build-office-android.sh [STAGE ...]
#   stages (default: all, in this order):
#     sdk      Android SDK, NDK and JDK 21 into $WORK/android-sdk (downloads about 3 GB)
#     engine   cross-compile the office engine for Android (hours; safe to re-run, make resumes)
#     online   configure the monorepo for the Android app and build the native library
#     app      build the app with gradle (release bundle .aab for Google Play, and an .apk for testing)
# Environment: WORK (default /var/tmp/nubo-office-android), SRC (the rebranded checkout, default /var/tmp/nubo-office/src),
#              APP_ID (default tech.nubosuite.office: must match the app created in Google Play Console),
#              VER (default 26.04.3.3-nubo1), ABI (default arm64-v8a).
#              Signing (release): KEYSTORE, KEYSTORE_PASS, KEY_ALIAS, KEY_PASS. Without them the .aab is unsigned (debug build only).
set -euo pipefail
WORK="${WORK:-/var/tmp/nubo-office-android}"
SRC_FROM="${SRC:-/var/tmp/nubo-office/src}"
APP_ID="${APP_ID:-tech.nubosuite.office}"
VER="${VER:-26.04.3.3-nubo1}"
ABI="${ABI:-arm64-v8a}"
NDK_VER="29.0.14206865"
SDKDIR="${WORK}/android-sdk"
JDKDIR="${WORK}/jdk21"
SRC="${WORK}/office"
LOGS="${WORK}/logs"; mkdir -p "${LOGS}"
case "$ABI" in
  arm64-v8a)   DISTRO=CPAndroidAarch64 ;;
  armeabi-v7a) DISTRO=CPAndroid ;;
  x86_64)      DISTRO=CPAndroidX86_64 ;;
  x86)         DISTRO=CPAndroidX86 ;;
  *) echo "unknown ABI $ABI" >&2; exit 1 ;;
esac
export CCACHE_DIR="${WORK}/ccache"; export CCACHE_MAXSIZE=10G
stages=("$@"); [[ ${#stages[@]} -eq 0 ]] && stages=(sdk engine online app)
has() { local s; for s in "${stages[@]}"; do [[ "$s" == "$1" ]] && return 0; done; return 1; }

if has sdk; then
  echo "==> sdk"
  if [[ ! -x "${JDKDIR}/bin/java" ]]; then
    mkdir -p "${JDKDIR}"
    curl -fsSL "https://api.adoptium.net/v3/binary/latest/21/ga/linux/x64/jdk/hotspot/normal/eclipse" | tar -xz -C "${JDKDIR}" --strip-components=1
  fi
  export JAVA_HOME="${JDKDIR}"; export PATH="${JAVA_HOME}/bin:${PATH}"
  if [[ ! -x "${SDKDIR}/cmdline-tools/latest/bin/sdkmanager" ]]; then
    mkdir -p "${SDKDIR}/cmdline-tools" "${WORK}/dl"
    curl -fsSL -o "${WORK}/dl/cmdline-tools.zip" "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
    unzip -q -o "${WORK}/dl/cmdline-tools.zip" -d "${SDKDIR}/cmdline-tools"
    mv "${SDKDIR}/cmdline-tools/cmdline-tools" "${SDKDIR}/cmdline-tools/latest"
  fi
  yes | "${SDKDIR}/cmdline-tools/latest/bin/sdkmanager" --sdk_root="${SDKDIR}" --licenses >/dev/null || true
  "${SDKDIR}/cmdline-tools/latest/bin/sdkmanager" --sdk_root="${SDKDIR}" \
      "platform-tools" "platforms;android-36" "build-tools;36.0.0" "ndk;${NDK_VER}"
fi

if has engine || has online || has app; then
  if [[ ! -d "${SRC}/engine" ]]; then
    echo "==> copying source to ${SRC}"
    mkdir -p "${SRC}"
    rsync -a --exclude 'engine/instdir' --exclude 'engine/workdir' --exclude '.flatpak-builder' "${SRC_FROM}/" "${SRC}/"
  fi
fi

if has engine; then
  echo "==> engine ($ABI)"
  cat > "${SRC}/engine/autogen.input" <<INPUT
--build=x86_64-unknown-linux-gnu
--with-android-ndk=${SDKDIR}/ndk/${NDK_VER}
--with-android-sdk=${SDKDIR}
--with-distro=${DISTRO}
--enable-ccache
--without-lang
--with-product-name=Nubo Office
--with-vendor=Nubo
INPUT
  ( cd "${SRC}/engine" && ./autogen.sh && make ) 2>&1 | tee -a "${LOGS}/engine.log" | tail -20
fi

if has online; then
  echo "==> online (native library and web interface)"
  export JAVA_HOME="${JDKDIR}"; export PATH="${JAVA_HOME}/bin:${PATH}"
  ( cd "${SRC}" && ./autogen.sh && ./configure --enable-androidapp --with-lo-builddir="${SRC}/engine" \
      --with-android-abi="${ABI}" --with-app-name="Nubo Office" --with-app-package-name="${APP_ID}" \
      --with-vendor=Nubo && make ) 2>&1 | tee -a "${LOGS}/online.log" | tail -20
fi

if has app; then
  echo "==> app (gradle)"
  export JAVA_HOME="${JDKDIR}"; export PATH="${JAVA_HOME}/bin:${PATH}"
  export ANDROID_HOME="${SDKDIR}"; export ANDROID_SDK_ROOT="${SDKDIR}"
  ( cd "${SRC}/android" && ./gradlew --no-daemon bundleRelease assembleRelease ) 2>&1 | tee -a "${LOGS}/gradle.log" | tail -30
  mkdir -p "${WORK}/out"
  find "${SRC}" -path '*build*' \( -name '*.aab' -o -name '*.apk' \) -newer "${LOGS}/gradle.log" -exec ls -la {} \; | tee "${WORK}/out/files.txt"
fi
