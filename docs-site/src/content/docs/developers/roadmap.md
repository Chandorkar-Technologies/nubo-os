---
title: Roadmap
description: An honest list of what Nubo OS does not do yet, with the reason each item matters. These are plans, not promises.
sidebar:
  order: 150
---

This page lists work that is planned or known to be missing. It is not a schedule. Nothing here has a release date, and any item can change or be dropped. Each entry says what exists today so you can tell a plan from a feature.

:::caution[Planned]
Everything under "Planned" below is not built. Do not rely on it, and do not describe it elsewhere as available.
:::

## Planned products and features

| Item | What exists today | What is missing |
|---|---|---|
| **Nubo Drive** | Nothing built. The Nubo account's mail server also speaks CalDAV, CardDAV and WebDAV, which the GNOME Online Accounts patch in `goa/` can use. | A synced file storage service and its desktop integration. |
| **Nubo Backup** | The desktop ships Déjà Dup, renamed "Backup" in the launcher (`data/apps/rebrand.list`). | A Nubo-run backup service and a Nubo-specific app. |
| **Migration app** | Nothing built. | A tool to bring files, settings and apps from Windows or macOS. |
| **Nubo Pro** | Nothing built. | A paid tier and what it would contain. |
| **A Nubo Store with its own cloud login** | The grey "click to download" icons (`nubo-get`, `nubo-app-stubs`) and the label "Nubo Store" on the software centre's desktop entry. `docs/apps-and-store.md` describes the design. | Sign in once and restore your apps on a new machine; a curated Popular page. |
| **Translations** | English only. | Localized interface and documentation. |
| **Benchmarks** | None published. The website notes say no speed or battery claim goes out without a measurement. | Measured results on real laptops, with the method, the date and the build. |

## Infrastructure work

| Item | What exists today | What is missing |
|---|---|---|
| **An arm64 CI runner** | `ci/debs-arm64.drone.yml` (inactive). arm64 packages are built in a VM and uploaded by hand. | A Drone runner on an arm64 machine, then the pipeline merged into `.drone.yml`. See [CI with Drone](/developers/ci-with-drone/). |
| **Desktop ISO in CI** | `iso/build-iso.sh`, run by hand. | A pipeline that builds, tests and uploads it. See [Building the desktop ISO](/developers/building-the-desktop-iso/). |
| **The sign-in broker as a .deb** | `authd-oidc`, the Nubo sign-in broker, is distributed as a snap, so snapd stays on the desktop and the machine still contacts Canonical's snap store. | A packaged broker, after which snapd can be dropped. `docs/ubuntu-endpoints.md` lists this as the fix. |
| **A mirror of Ubuntu's archive** | Nubo Cumulus caches what is requested. | A full mirror of `resolute` (the repository README estimates about 300 GB plus a daily sync); worth it only at real traffic. |
| **Own copies of Ubuntu's base ISOs** | Downloads come from Canonical, signed by Canonical. | Pinning them into Nubo's own bucket. |
| **Rotating the archive key** | The key has a five-year expiry. | A written plan and a `nubo-archive` update that carries a new key. See [Archive internals](/developers/archive-internals/). |

## Known gaps in what is built

- **Server flavours** (Server, Virtualization, Containers, Edge) are built and published by CI, but not yet tested on hardware.
- **Raspberry Pi and cloud images** (`images/build-pi.sh`, `images/build-cloud.sh`) are untested, and not part of the Drone pipelines.
- **Nubo account sign-in** has not been approved end to end with a real account. Treat it as early access.
- **The Nubo provider for GNOME Online Accounts** (`goa/`) has been tested only against a fake server and the patched Settings is not installed by default. It is a preview.
- **`lsb_release` still reports Ubuntu.** Renaming it must be paired with a change to the unattended-upgrades origin patterns, or security updates stop (`repo/README.md`).
- **The installer's location guess** (`geoip.ubuntu.com`) is still contacted on the desktop. A fix is to patch the installer or pre-seed the time zone.
- **Some Ubuntu names remain** in places that cannot change safely. `data/os/README.md` records what is kept on purpose.
- **The dark mode of modern apps** is libadwaita's own dark grey, not pure black (`README.md`).
- **Nubo Mail** can be repackaged from a separate Tauri build with `mail/repack.sh`; it is not part of the `nubo-os` source package or the desktop metapackage.
- **Two release workflows** exist: the Drone pipelines and an older GitHub Actions file. See [CI with Drone](/developers/ci-with-drone/).

## How to influence the list

Open a request or send a note to support@nubo.email. A feature moves from this page into the documentation only when it exists in the repository and has been tested. Until then it stays here, labelled as planned.

## Verify

When you move an item out of this page, check that it is built:

1. The code is in the repository and listed in a package (`debian/*.install`).
2. A CI or manual test result exists in the [Testing checklist](/developers/testing-checklist/).
3. The pages in [Desktop](/desktop/), [Server](/server/) or [Reference](/reference/) that mention it say so without a "Planned" note.

## Troubleshooting

- **A page elsewhere describes one of these as available.** Correct it, add a `:::caution[Planned]` note, and tell the page's owner.
- **An item here is already built.** Remove it from this page in the same change that documents it.

## See also

- [Developers](/developers/)
- [Repository layout](/developers/repo-layout/)
