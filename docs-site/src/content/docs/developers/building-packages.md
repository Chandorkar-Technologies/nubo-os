---
title: Building the packages
description: Build the Nubo OS .deb files with dpkg-buildpackage, including build dependencies, pinned upstream sources and the release key check.
sidebar:
  order: 30
---

Nubo OS is one source package, `nubo-os`, that produces all the binary packages. It uses `debhelper-compat (= 13)` and the format `3.0 (native)`, which means the version number lives only in `debian/changelog` and there is no separate upstream tarball.

## Before you begin

- A Linux machine running Ubuntu 26.04 (or a container of `ubuntu:26.04`). On a Mac, use a VM; see [Development loop](/developers/development-loop/).
- Network access for the first step (`vendor/fetch.sh`). The build itself never touches the network.
- Tools: `git`, `curl`, `ca-certificates`, `build-essential`, `devscripts` and `equivs`. These are the same tools the CI image installs.

## Steps

1. Fetch the pinned upstream sources into `vendor/`:

   ```bash
   vendor/fetch.sh
   ```

2. Install the build dependencies. On a machine with source repositories enabled, either of these works:

   ```bash
   sudo apt-get build-dep -y ./
   ```

   ```bash
   sudo mk-build-deps -i -r -t 'apt-get -y' debian/control
   ```

   CI uses `mk-build-deps`; the development VM script uses `apt-get build-dep`.

3. Build the binary packages without signing:

   ```bash
   dpkg-buildpackage -us -uc -b
   ```

4. Collect the results. `dpkg-buildpackage` writes the `.deb` files next to the source directory, one level up:

   ```bash
   mkdir -p out && mv ../nubo-*_*.deb out/
   ```

## What gets built

The packages come from `debian/control`.

| Package | Architecture | Purpose |
|---|---|---|
| `nubo-desktop` | all | Metapackage: the whole desktop |
| `nubo-theme`, `nubo-icons`, `nubo-sounds`, `nubo-glass` | all | Look and feel |
| `nubo-branding` | all | Identity, wallpapers, boot screen, desktop defaults, first-boot cleanup |
| `nubo-installer` | all | Installer appearance (installation media only) |
| `nubo-account` | all | Nubo account sign-in |
| `nubo-search` | amd64, arm64 | The launcher, unpacked from a pinned AppImage |
| `nubo-notify`, `nubo-apps` | all | Notification centre and agent; popular app launchers |
| `nubo-base`, `nubo-archive` | all | Network, time and update settings; apt source and key |
| `nubo-server-core`, `nubo-server-base`, `nubo-edge`, `nubo-podman`, `nubo-incus` | all | Server and its flavours |

`nubo-search` is the only package built per CPU. Because the arm64 build is released on its own, `debian/rules` gives `nubo-desktop` the dependency `nubo-search (>= 0.7.0)` through the substitution variable `nubo:search`, instead of an exact version.

## Pinned upstream sources

`vendor/fetch.sh` is the single place where outside code enters the build. Git sources are pinned by commit, downloads by SHA-256. A mismatch stops the script and deletes the partial download.

| Name | Used for | Pin |
|---|---|---|
| `colloid-gtk` | Application and shell theme (GPL-3.0) | commit `fe11342f37f124f1b29d44cf33e9a06053f4bba2` |
| `blur-my-shell.zip` | Glass effect, release 73 | sha256 `237a59e04b3cffd3fb86aa3cd18b32f929c61e2af8dcc781379364a59d53b129` |
| `app-grid-tuner.zip` | App grid rows and columns, release 9 | sha256 `1f22a99698cb626c975d11c5941a413d069ec0614ecaf993042aa1804faa3f67` |
| `glass-widgets.zip` | Desktop widgets, release 8 | sha256 `ba0ceef0b730fc1e9b439d591d2a9a10170a578a4cc5dc6066cb69d59bde853e` |
| `vicinae.AppImage` | Launcher for amd64, release 0.29.1 | sha256 `44906f2290f0934572f1977de8aa529c3b67d104025a489b32f226fe3b0f3dd9` |
| `vicinae-arm64.AppImage` | Launcher for arm64, release 0.29.1 | sha256 `369feb20fe987d04ffb1a0b354f28773bd1a1a550a31cdcb22d968e39b141ec0` |

To take an upstream update, change the pin in `fetch.sh`, rebuild and re-test. For a file, compute the new checksum yourself from a copy you have inspected:

```bash
curl -fsSL -o /tmp/new.zip "https://example.org/the-new-release.zip"
sha256sum /tmp/new.zip
```

`debian/rules` checks that these files exist before it starts, and fails with a message such as `vendor/colloid-gtk missing: run vendor/fetch.sh`.

## Release builds and the archive key

The package `nubo-archive` ships the apt source and the public signing key. `override_dh_auto_install` in `debian/rules` controls how that works:

- If `repo/nubo-archive-keyring.gpg` exists and is not empty, it is copied into the package.
- If it is missing and `NUBO_RELEASE` is set (any non-empty value), the build fails with `repo/nubo-archive-keyring.gpg missing`.
- If it is missing and `NUBO_RELEASE` is not set, the build continues with a warning, ships an empty key file and writes `Enabled: no` into `nubo.sources`. A development build therefore installs a disabled source and cannot pull packages from the archive.

CI sets `NUBO_RELEASE: "1"`. Set it yourself when you build something you intend to publish:

```bash
NUBO_RELEASE=1 dpkg-buildpackage -us -uc -b
```

The key in the repository is the public half. The key's fingerprint is `EE1A4B749E23201501F203360F7401D7AF7D2593`. The private half never goes in git: see [Archive internals](/developers/archive-internals/).

## Verify

List the contents and metadata of a package:

```bash
dpkg-deb -I out/nubo-archive_*_all.deb
dpkg-deb -c out/nubo-archive_*_all.deb
```

For a release build, the second command should list `./usr/share/keyrings/nubo-archive-keyring.gpg`, and the archive key should not be empty:

```bash
dpkg-deb -x out/nubo-archive_*_all.deb /tmp/archive-check
test -s /tmp/archive-check/usr/share/keyrings/nubo-archive-keyring.gpg && echo "key present"
grep Enabled /tmp/archive-check/etc/apt/sources.list.d/nubo.sources || echo "source enabled"
```

## Troubleshooting

- **`vendor/colloid-gtk missing: run vendor/fetch.sh`.** Run the script from any directory; it changes into its own folder.
- **`checksum mismatch`.** The upstream file changed or the download was cut short. Run the script again once; if it fails again, investigate before changing the pin.
- **`repo/nubo-archive-keyring.gpg missing`.** You set `NUBO_RELEASE` without the key. Unset it for a development build.
- **Build-dependency errors about missing packages.** The `Build-Depends` list includes GNOME apps that exist in Ubuntu 26.04. Building on an older release will not find them.
- **No `.deb` files in `out/`.** `dpkg-buildpackage` puts them in the parent directory. Check `ls ..`.
- **Icon files missing after a build on a Mac.** Do not build on macOS; see [Development loop](/developers/development-loop/).

## See also

- [Packaging notes](/developers/packaging-notes/)
- [CI with Drone](/developers/ci-with-drone/)
