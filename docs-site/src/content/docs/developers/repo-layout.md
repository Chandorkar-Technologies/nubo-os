---
title: Repository layout
description: Every top-level directory in the Nubo OS repository, what it holds and which package or script uses it.
sidebar:
  order: 10
---

This page is a map of the repository. The tree below is the real one; where a directory is not part of any package, the table says so.

## Top-level files

| File | What it is |
|---|---|
| `.drone.yml` | The Drone pipelines that build, publish and promote releases, and deploy the docs. See [CI with Drone](/developers/ci-with-drone/). |
| `.github/workflows/release.yml` | An older GitHub Actions release workflow. The header of `.drone.yml` describes Drone as the current path. See the note in [CI with Drone](/developers/ci-with-drone/). |
| `.gitignore` | Keeps build output, fetched upstream sources, installer images and the private archive key out of git. |
| `LICENSE` | GNU General Public License, version 3. |
| `LICENSE.brand` | The exception for the Nubo name and mark. See [Brand and licence rules](/developers/brand-and-licence-rules/). |
| `README.md` | A short overview of the packages, the development VMs and the installer image. |

## Directories

| Directory | What it holds | Used by |
|---|---|---|
| `account/` | Sign-in with a Nubo account: first-boot setup script and unit, the broker registration for authd (`brokers.d/nubo.conf`), the setup app and its desktop entries. | package `nubo-account` |
| `apps/` | `nubo-get` (download an app from Flathub and open it), `nubo-app-stubs` (writes the grey launchers) and its user service. | package `nubo-apps` |
| `base/` | Network check, time servers, release-upgrade and debuginfod settings that replace Ubuntu's defaults. | package `nubo-base` |
| `brand/` | Logo SVGs (`logo/`), the eight wallpaper photographs and their licence record (`wallpapers/`), sound audition tools, and the scripts that generate renamed or hidden desktop entries, the login screen theme and the icon layer. | `debian/rules`, package `nubo-branding` |
| `ci/` | Shell scripts the Drone pipelines call: staging upload, publish, promote, image build, docs deploy, cleanup, and the helper that points apt at Cumulus. `debs-arm64.drone.yml` is an inactive pipeline. | `.drone.yml` |
| `data/` | Files shipped as they are: app lists (`apps/`), apt source for Mozilla (`apt/`), the boot background list (`backgrounds/`), app grid folders (`dconf/`), the first-boot script (`firstboot/`), the widgets extension changes (`glass-widgets/`), the gsettings override (`gschema/`), icons, system identity files (`os/`), the boot screen (`plymouth/`), sound theme index and extra shell CSS. | package `nubo-branding` and others |
| `debian/` | Package definitions: `control`, `rules`, `changelog`, install lists and maintainer scripts. See [Packaging notes](/developers/packaging-notes/). | `dpkg-buildpackage` |
| `docs/` | Internal design notes in Markdown: `apps-and-store.md`, `ubuntu-endpoints.md`, `website-strategy.md`. Not the published documentation. | people |
| `docs-site/` | This documentation site (Astro Starlight), its `WRITING.md` rules, `FACTS.md`, and the hosting Worker `worker.js`. See [Contributing to these docs](/developers/docs-contributing/). | Drone `docs` pipeline |
| `goa/` | A patch set that adds a "Nubo" provider to GNOME Online Accounts, with build scripts and tests. Builds Ubuntu's `gnome-online-accounts` as version `<ubuntu version>+nubo1`. Preview: not installed by default. | run by hand |
| `images/` | `build-cloud.sh` (qcow2, vhd, vmdk) and `build-pi.sh` (Raspberry Pi), plus a README with their status. | run by hand or CI |
| `installer/` | Installer branding: slide template, `make-installer-branding.sh` and `build-installer-snap.sh`, which rebuilds the installer app with the product name changed. | `debian/rules`, `iso/build-iso.sh` |
| `iso/` | `build-iso.sh` (desktop), `build-server-iso.sh` (server), and the answer files `autoinstall.yaml`, `server-user-data` and `server-meta-data`. | run by hand or CI |
| `mail/` | `repack.sh`, which repackages a separate Tauri build of Nubo Mail as a package named `nubo-mail`. Not part of the `nubo-os` source package. | run by hand |
| `menu/` | The `nubo-menu` GNOME Shell extension (the top-bar logo and text). | package `nubo-branding` |
| `notify/` | The notification agent, its user service, `background-apps.json` and the notification-centre extension. | package `nubo-notify` |
| `repo/` | The apt archive: `publish.sh`, reprepro configuration (`conf/`), the public key, the client source files, `nubo-channel`, the unattended-upgrades file, Ubuntu source files for Cumulus, and `cumulus-worker.js`. | package `nubo-archive`, CI |
| `reports/` | Market and requirements research, as Markdown. | people |
| `research_notes/` | Research on other projects' documentation structure and related studies. | people |
| `screenshots/` | Review captures, one folder per build. | people |
| `search/` | Launcher wrapper `nubo-search.sh`, its configuration `nubo.json` and desktop entries. | package `nubo-search` |
| `server/` | Server identity files, SSH and sysctl settings, firewall script, message of the day, the `nubo-incus-init` and `nubo-podman-init` commands and the Incus preseed. | packages `nubo-server-core`, `nubo-incus`, `nubo-podman` |
| `theme-validation/` | Scripts that try the Colloid-based look on a stock Ubuntu desktop VM and undo it. | run by hand |
| `tools/` | `audit-ubuntu-traces.sh` lists what on an installed system still shows or links to Ubuntu. `bisect-whitelabel.sh` helps find which part of the installer white-label file breaks the installer. | run by hand |
| `vendor/` | `fetch.sh` and the pinned upstream sources it downloads. The downloads are not committed. | `debian/rules` |
| `vm/` | Development VM scripts: sync and build, provision, create Proxmox VMs, screenshots, clicks and keys. See [Development loop](/developers/development-loop/). | people |

## Inside `data/`

| Path | Contents |
|---|---|
| `data/apps/` | `popular.list`, `hide.list`, `rebrand.list`, and two desktop entries (`nubo-help.desktop`, `nubo-maps.desktop`). |
| `data/apt/` | Mozilla's apt source, pin and signing key (Firefox as a regular package). |
| `data/os/` | `os-release`, `issue`, `issue.net`, `lsb-release`, `legal`, the boot menu script (`grub/10_linux`), the GRUB distributor setting and the text boot screen. Its `README.md` explains what is renamed and what stays Ubuntu's. |
| `data/gschema/` | `90_nubo.gschema.override`, the desktop defaults. |
| `data/dconf/` | App grid folders and the dconf profile. |
| `data/firstboot/` | `nubo-first-boot` and its systemd unit. |

## Where a change goes

| You want to change | Edit |
|---|---|
| A default setting (theme, dock, wallpaper) | `data/gschema/90_nubo.gschema.override` |
| Which popular apps appear as grey icons | `data/apps/popular.list` |
| A server default (SSH, firewall, sysctl) | `server/` and `debian/nubo-server-core.install` |
| What a flavour installs | `debian/control` and the `PKGS` lists in `iso/build-server-iso.sh`, `images/build-cloud.sh`, `images/build-pi.sh` |
| How a release is built | `.drone.yml` and `ci/` |
| The archive layout | `repo/publish.sh` and `repo/conf/` |

## Verify

From the repository root, list the top level and compare it with this page:

```bash
ls -d */ 
```

## Troubleshooting

- **A directory is missing on your machine.** `vendor/colloid-gtk/`, `build/` and `out/` are created by a build and are not in git. Run `vendor/fetch.sh`.
- **A file is "missing" after cloning on a Mac.** Some upstream sources hold names that differ only by case. Build on Linux; see [Development loop](/developers/development-loop/).

## See also

- [Packaging notes](/developers/packaging-notes/)
- [Customising the desktop](/developers/customising-the-desktop/)
