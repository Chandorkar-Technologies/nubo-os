---
title: How updates work
description: The path a change takes from a Nubo build to the update that arrives on your machine.
sidebar:
  order: 10
---

**Applies to:** Desktop, Server, Virtualization, Containers, Edge

A Nubo OS machine is an Ubuntu 26.04 LTS system with extra packages on top. Updates therefore have two sources that do not depend on each other. This page explains both and how a Nubo change gets to you.

## Two sources, one tool

Your machine reads two kinds of package lists:

1. **Ubuntu's packages.** The operating system underneath: the kernel, GNOME, security fixes, almost everything. These are built and signed by Ubuntu. Nubo does not change them.
2. **Nubo's packages.** The `nubo-*` packages: theme, icons, branding, the launcher, the notification centre, the server settings. These are built by Chandorkar Technologies and signed with the Nubo archive key.

Both lists are read by apt, so `apt update`, `apt upgrade` and the graphical update tool see them together. Nothing you install from one source needs a special command.

## The path of a Nubo change

```text
 source code        build              beta             stable
 (git repository)   (CI, on a tag)     channel          channel
       |                |                 |                |
       |  tag v0.8.0-betaN                |                |
       +--------------> build packages -->| publish        |
                        (amd64, arm64)    |                |
                                          |  tag v0.8.0    |
                                          +--------------->| promote
                                          |  (no rebuild)  |
                                          v                v
                                   archive.nubosuite.tech (apt archive)
                                          |                |
                                          |  nubo-channel  |  default
                                          v                v
                                       your machine: apt update / apt upgrade
```

In words:

1. **Build.** When the maintainers push a version tag whose name contains a dash, such as `v0.8.0-beta1`, the build system compiles the Nubo packages for amd64 (and arm64 packages are added separately). The packages are put in a staging area first.
2. **Beta.** The staged packages are added to the archive's beta channel, the suite `resolute-beta`. People who chose the beta channel see them at their next `apt update`. The same tag also builds the server installer images, which are uploaded to the archive under `iso/`.
3. **Promote.** When the maintainers push a tag without a dash, such as `v0.8.0`, the build system copies what the beta channel carries into the stable channel, the suite `resolute`. Nothing is rebuilt, so stable gets byte-for-byte the packages that testers already ran.
4. **Archive.** The archive is a set of static files: package files, indexes and a signed list of checksums. It has no server program running behind it.
5. **Your machine.** apt downloads the signed index, checks the signature against the key in `/usr/share/keyrings/nubo-archive-keyring.gpg`, then downloads and installs the packages that are newer than yours.

Stable is only ever filled by promotion. The beta and stable channels therefore never hold two different builds of the same version.

:::note
Every release needs a new version number in the package changelog. The package files of both channels share one pool, and a file with the same name but different contents is refused. See [Release versions and support](/updates/release-versions-and-support/).
:::

## Where Ubuntu's packages come from

By default, `ubuntu.sources` on a Nubo OS machine points at **Nubo Cumulus**, a cache run by Nubo at `archive.nubosuite.tech/cumulus` (amd64) and `/cumulus-arm` (arm64). Cumulus fetches the files from Ubuntu and keeps copies close to you. It does not rewrite anything: the files are Ubuntu's and stay signed by Ubuntu. If Cumulus cannot be reached, apt falls back to Ubuntu's own servers by itself. See [Nubo Cumulus](/updates/nubo-cumulus/).

## What installs by itself

Security updates from Ubuntu, regular updates from Ubuntu and stable-channel updates from Nubo are set up to install automatically through unattended upgrades, without rebooting. The beta channel is never installed automatically. See [Automatic updates](/updates/automatic-updates/).

## What Nubo does not do

- Nubo does not host a full copy of Ubuntu's archive. The archive carries only Nubo's own packages; Ubuntu's files are fetched through the Cumulus cache and are not stored there.
- Nubo does not alter Ubuntu's signatures. Ubuntu's keys still verify Ubuntu's packages.
- Release upgrades with `do-release-upgrade` are switched off (the prompt is set to `never`). The Nubo base configuration notes that release upgrades are meant to be delivered through the Nubo archive. No second Nubo release exists yet, so there is no upgrade path to describe.

## See also

- [The Nubo archive](/updates/the-nubo-archive/)
- [Channels: stable and beta](/updates/channels-stable-and-beta/)
- [Verify signatures and checksums](/updates/verify-signatures-and-checksums/)
- [Ubuntu Server documentation: package management](https://ubuntu.com/server/docs) for how apt itself works
