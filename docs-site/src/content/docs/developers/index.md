---
title: Developers
description: How Nubo OS is built, tested, released and documented, for people who want to read the code, build it or send a fix.
sidebar:
  order: 1
---

Nubo OS is a set of Debian packages, a few installer images and a package archive, all kept in one repository: <https://github.com/Chandorkar-Technologies/nubo-os>. This section is for people who want to build it, change it or help with it. If you only want to use Nubo OS, start with [Start here](/start/), [Desktop](/desktop/) or [Server](/server/).

The base system is Ubuntu 26.04 LTS. Nubo OS does not fork Ubuntu: it adds packages on top, replaces a small number of Ubuntu files through `dpkg-divert`, and serves Ubuntu's own packages through a cache. Understanding that one idea makes the rest of the code easier to read.

## How the pieces fit

```text
source (this repository)
   |  dpkg-buildpackage          one source package, "nubo-os", many .deb files
   v
.deb files
   |  repo/publish.sh            reprepro builds a signed apt archive
   v
archive.nubosuite.tech           Cloudflare R2 bucket; suites resolute (stable), resolute-beta
   |  apt on every machine
   v
installed systems                desktop, server, edge, containers, virtualization

Ubuntu's packages and images  -> Nubo Cumulus (Cloudflare Worker) -> same machines
```

## Pages in this section

### Orientation and daily work

- [Repository layout](/developers/repo-layout/): every top-level directory and what it holds.
- [Development loop](/developers/development-loop/): build and install the packages in an arm64 virtual machine from a Mac.
- [Testing checklist](/developers/testing-checklist/): the manual checks to run before a release.

### Building

- [Building the packages](/developers/building-packages/): build dependencies, pinned upstream sources and the release switch.
- [Packaging notes](/developers/packaging-notes/): diversions, configuration files, maintainer scripts, conflicts and versions.
- [Building the desktop ISO](/developers/building-the-desktop-iso/): what `iso/build-iso.sh` does, stage by stage. Not yet built by CI.
- [Building the server images](/developers/building-server-images/): `iso/build-server-iso.sh`, the four flavours and the answer file.

### Releasing

- [CI with Drone](/developers/ci-with-drone/): the pipelines, what triggers them and which secrets they need.
- [Publishing releases](/developers/publishing-releases/): from a beta tag to the stable channel.
- [Archive internals](/developers/archive-internals/): reprepro, suite lists, signing and the R2 bucket.
- [The Cumulus Worker](/developers/cumulus-worker/): a walk-through of the code that caches Ubuntu's archive.

### Customising and contributing

- [Customising the desktop](/developers/customising-the-desktop/): the lists and files that decide which apps, names and wallpapers ship.
- [Brand and licence rules](/developers/brand-and-licence-rules/): what you may reuse and what is protected.
- [Contributing to these docs](/developers/docs-contributing/): add or edit a page, preview it and publish it.
- [Roadmap](/developers/roadmap/): what is planned and not built yet. These are plans, not promises.

## Ground rules

- The repository is the authority. If a page here disagrees with the code, the code is right and the page needs fixing.
- Every release needs a new version in `debian/changelog`. The archive refuses a package file that reuses a name with different contents.
- Package builds run on Linux. Some upstream sources contain file names that differ only by case, which macOS cannot hold.
- Nothing secret goes in git. The archive's private signing key and the storage keys live in CI secrets.

## Reporting a problem

Send bugs and questions to support@nubo.email. Security reports go to security@nubosuite.tech.
