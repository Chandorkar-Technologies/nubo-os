---
title: Upgrading between releases
description: How Nubo OS Server releases reach your machine, why do-release-upgrade is switched off, and what to do today.
sidebar:
  order: 120
---

**Applies to:** Server, Virtualization, Containers, Edge

This page explains how a Nubo OS Server moves from one release to the next. There is only one release so far, Nubo OS 1 "Flow", so no release-to-release upgrade exists yet. What does exist is the rule for how a future release is delivered, and a clear statement of what to avoid.

## Explanation: how releases arrive

On Ubuntu, `do-release-upgrade` offers to move you to the next Ubuntu release, and the login message tells you when one is available. Nubo OS turns that off. The package `nubo-base` installs this file over Ubuntu's:

```text title="/etc/update-manager/release-upgrades"
# Nubo OS: release upgrades are delivered through the Nubo archive, not by do-release-upgrade.
[DEFAULT]
Prompt=never
```

`Prompt=never` means the system never asks you to upgrade to a new Ubuntu release. This has two effects:

1. A machine running Nubo OS does not jump to the next Ubuntu release by accident. Ubuntu's next release would not have Nubo's packages, identity or settings.
2. Nubo's own releases are meant to arrive through the Nubo archive at https://archive.nubosuite.tech, like any other package update, signed with the archive key. The channel (`stable` or `beta`, see [Updates](/updates/)) decides which builds you receive.

`nubo-server-core` also makes Ubuntu's `91-release-upgrade` login-message script non-executable, so the login message no longer announces new releases. Ubuntu's original release-upgrade file is kept as `/etc/update-manager/release-upgrades.ubuntu` and returns if you remove `nubo-base`.

:::caution[Planned]
A procedure for upgrading from Nubo OS 1 "Flow" to a later Nubo OS release is not yet written, because no later release exists. This page will describe it when one does. Nubo OS 1 is based on Ubuntu 26.04 LTS, and its base system receives security updates until April 2031.
:::

## What to do today

Keep the current release up to date. That is all a server on Nubo OS 1 needs.

### Before you begin

- Logged in as a user with `sudo`.
- A recent backup ([Backups](/server/administer/backups/)).

### Steps

1. Look at the update channel:

   ```bash
   sudo nubo-channel
   ```

   It prints `stable` or `beta`. Servers should normally stay on `stable`. Switch with `sudo nubo-channel stable`, or `sudo nubo-channel beta` for earlier builds.

2. Install all updates:

   ```bash
   sudo apt update
   sudo apt full-upgrade
   sudo apt autoremove
   ```

3. Reboot if needed:

   ```bash
   test -f /var/run/reboot-required && sudo reboot
   ```

### Verify

```bash
grep PRETTY_NAME /etc/os-release
cat /etc/update-manager/release-upgrades
apt list --upgradable 2>/dev/null
```

The first shows `Nubo OS Server 1`, the second shows `Prompt=never`, and the third lists nothing when you are up to date.

## What not to do

- **Do not run `do-release-upgrade`.** Nubo does not support it, and it is switched off. Forcing an Ubuntu release upgrade would move the machine to a release that Nubo has not built or tested.
- **Do not edit `/etc/apt/sources.list.d/*.sources` to point at a different suite** (for example the next Ubuntu codename). The suite in `nubo.sources` is `resolute`, or `resolute-beta` on the beta channel.
- **Do not change the Ubuntu identity files by hand.** `/usr/lib/os-release`, `/etc/issue`, `/etc/issue.net` and `/etc/lsb-release` belong to `nubo-server-core`.

## Troubleshooting

**`do-release-upgrade` says "No new release found".** That is the intended result of `Prompt=never`.

**You changed the channel and `apt` shows many updates.** Moving from beta to stable can offer older versions; `apt full-upgrade` handles it, but read the list before you confirm.

**You want to go back to Ubuntu's own behavior.** Remove `nubo-base`, which restores Ubuntu's original release-upgrade file. Doing so also removes Nubo's time server list and unmasks the Canonical services listed in [What the defaults do](/server/security/what-the-defaults-do/). `nubo-server-core` depends on it and would be removed too. This is not a tested path.

**`apt update` fails after you edited a source file.** Restore the original from `/usr/share/nubo/ubuntu-sources/` or reinstall the package: `sudo apt install --reinstall nubo-archive`.

## See also

- [Updates](/updates/)
- [Updates and reboots](/server/administer/updates-and-reboots/)
- [Ubuntu Server: upgrade your release](https://ubuntu.com/server/docs/how-to/software/upgrade-your-release/)
