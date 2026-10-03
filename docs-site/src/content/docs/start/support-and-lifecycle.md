---
title: Support and lifecycle
description: How long Nubo OS 1 receives security updates, and how the stable and beta channels work.
sidebar:
  order: 30
---

**Applies to:** Desktop, Server

This page explains how long you can keep using Nubo OS 1 "Flow" with security updates, and how updates reach your machine.

## The support period

Nubo OS 1 is built on Ubuntu 26.04 LTS. Ubuntu supports a long-term release with security updates for five years, which runs to April 2031. Nubo OS inherits that period for the base system, because Nubo OS does not replace Ubuntu's packages. Nubo's own packages (the theme, the notification centre, the launcher and so on) are updated by Nubo through its own archive.

| Part | Where updates come from | Period |
|---|---|---|
| Ubuntu base system | Ubuntu's archive, through Nubo Cumulus, with Ubuntu as fallback | Five years from the base release, to April 2031 |
| Nubo packages (`nubo-*`) | `archive.nubosuite.tech`, signed with the Nubo archive key | While Nubo OS 1 is maintained |
| Apps from Flathub | Flathub, through Flatpak | Set by each app's publisher |

:::note
Nubo OS does not include the Ubuntu Pro client. Ubuntu's optional extended maintenance beyond the standard period is therefore not offered through Nubo OS.
:::

Nubo has not published a separate end-of-life date for its own packages. Treat April 2031 as the outer limit set by the base.

## Release status

Nubo OS 1 is in beta. A release is built from a tag in the repository: a tag like `v0.8.0-beta4` builds and publishes to the beta channel. A tag like `v0.8.0` promotes the beta packages to the stable channel without rebuilding them.

## Update channels

The package archive has two channels, which are suites in the archive:

| Channel | Suite name | Use |
|---|---|---|
| Stable | `resolute` | Default. Packages that were promoted from beta. |
| Beta | `resolute-beta` | Early packages for people who want to test. |

Check or change your channel with the `nubo-channel` command:

```bash
nubo-channel
sudo nubo-channel beta
sudo nubo-channel stable
```

Run `sudo apt upgrade` afterward to take the new packages. The full procedure is in [Updates](/updates/).

## Automatic security updates

The package `nubo-archive` turns on automatic installation of Nubo and Ubuntu security updates. On servers, the Server, Containers and Edge editions also include `unattended-upgrades` through their package lists.

## Moving to a later release

Release upgrades are delivered through the Nubo archive. The Ubuntu release-upgrade prompt is switched off (`Prompt=never`), so do not run `do-release-upgrade` on Nubo OS. Nubo will document the path to a later Nubo OS release when one exists.

## Where to ask about support

See [Getting help](/start/getting-help/). For security reports, write to security@nubosuite.tech.

## See also

- [What is different from Ubuntu](/start/what-is-different-from-ubuntu/)
- [Updates](/updates/)
- [Frequently asked questions](/start/faq/)
