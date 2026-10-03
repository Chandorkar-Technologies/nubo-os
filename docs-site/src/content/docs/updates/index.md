---
title: Updates and the archive
description: How Nubo OS gets its updates, where they come from, and how to control and check them.
sidebar:
  order: 1
---

Nubo OS is built on Ubuntu 26.04 LTS. Your machine gets updates from two places at once: Ubuntu's own packages, and the Nubo packages that add the Nubo look, apps and server settings. Both arrive through the normal Ubuntu package system (apt), so the tools you already know work the same way.

This section explains where the packages live, how they get from our build machines to yours, and how to change the defaults: pick the beta channel, turn automatic updates on or off, stop using Nubo Cumulus, or check that a download is genuine.

## Pages in this section

### Understand

- [How updates work](/updates/how-updates-work/): the path a change takes from a build to your machine, in one diagram.
- [The Nubo archive](/updates/the-nubo-archive/): what is at archive.nubosuite.tech, how it is laid out and which key signs it.
- [Channels: stable and beta](/updates/channels-stable-and-beta/): the two update streams and how to switch between them.
- [Automatic updates](/updates/automatic-updates/): which updates install on their own and which wait for you.
- [Nubo Cumulus](/updates/nubo-cumulus/): the cache that serves Ubuntu's packages and images, and the fallback if it is down.
- [Release versions and support](/updates/release-versions-and-support/): how versions and tags are named and how long updates last.
- [Privacy and network endpoints](/updates/privacy-and-network-endpoints/): which addresses a Nubo OS machine contacts, and which contacts to Canonical were switched off.

### Do

- [Use Ubuntu's servers directly](/updates/use-ubuntus-servers-directly/): bypass Nubo Cumulus and fetch Ubuntu packages from Ubuntu.
- [Verify signatures and checksums](/updates/verify-signatures-and-checksums/): check the archive key and an installer image.
- [Build a private mirror](/updates/build-a-private-mirror/): an outline for running your own copy of the archive. Not supported yet.

## Quick answers

| I want to... | Do this |
|---|---|
| See which channel I follow | `sudo nubo-channel` |
| Test early builds | `sudo nubo-channel beta` |
| Go back to the default | `sudo nubo-channel stable` |
| Stop Ubuntu packages going through Nubo | See [Use Ubuntu's servers directly](/updates/use-ubuntus-servers-directly/) |

For every command and file mentioned here, see the [reference](/reference/).
