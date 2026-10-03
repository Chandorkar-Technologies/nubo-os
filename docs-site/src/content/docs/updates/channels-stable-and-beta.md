---
title: "Channels: stable and beta"
description: Choose between the stable and beta update channels with nubo-channel, and go back to stable.
sidebar:
  order: 30
---

**Applies to:** Desktop, Server, Virtualization, Containers, Edge

Nubo packages come in two channels. Stable is the default and is what you should run on a machine you depend on. Beta carries early builds so testers can try them first.

## What each channel is

| | Stable | Beta |
|---|---|---|
| Suite name | `resolute` | `resolute-beta` |
| What it carries | Builds that were first in beta and then promoted, without a rebuild | New builds as soon as they are published |
| Installed automatically | Yes, with the other automatic updates | No |
| Who it is for | Everyone | Testers who accept more risk |

The beta channel has no stricter meaning than this: it is a build that has been published but not yet promoted. Beta builds are tested less. Version numbers of beta builds contain `~beta`, for example `0.8.0~beta3`. See [Release versions and support](/updates/release-versions-and-support/).

:::caution
The channel setting covers only the Nubo packages (`nubo-*`). Ubuntu's packages are the same on both channels.
:::

## Before you begin

- A Nubo OS machine with the `nubo-archive` package installed (it is part of every edition).
- Administrator rights (`sudo`).
- A network connection.

## See which channel you follow

```bash
sudo nubo-channel
```

The command prints `stable` or `beta`. It needs `sudo` even to read the setting.

## Switch to beta

1. Run:

   ```bash
   sudo nubo-channel beta
   ```

2. The command rewrites the `Suites:` line in `/etc/apt/sources.list.d/nubo.sources`, refreshes the package list for that source, and prints `Channel: beta. Run: sudo apt upgrade`.
3. Install what is new:

   ```bash
   sudo apt upgrade
   ```

   On the desktop you can instead open the Nubo Store and use its updates page. <!-- verify label -->

## Switch back to stable

1. Run:

   ```bash
   sudo nubo-channel stable
   ```

2. Refresh and look at what apt wants to do:

   ```bash
   sudo apt update
   apt list --upgradable
   ```

:::note
Going back to stable does not downgrade packages. If beta gave you a version newer than stable has, apt keeps it until stable catches up with a newer promoted version. To force older versions, you have to install them yourself with apt and a version number. That is only worth doing if a beta build broke something. In that case, please tell support@nubo.email first.
:::

## Verify

```bash
sudo nubo-channel
grep '^Suites:' /etc/apt/sources.list.d/nubo.sources
apt-cache policy nubo-base
```

- The first command prints the channel you chose.
- The second prints `Suites: resolute` for stable or `Suites: resolute-beta` for beta.
- The third shows the installed version and the candidate version, and which source it comes from.

## Troubleshooting

**`Run with sudo.`**
You ran the command without administrator rights. Run it again with `sudo`. The command checks this before anything else, including when you only want to read the channel.

**`Usage: nubo-channel [stable|beta]`**
The word after the command was not `stable` or `beta`. Spell it exactly. Nothing was changed.

**`apt update` shows an error for archive.nubosuite.tech after switching.**
Check your network, then run `sudo apt update` again. The beta suite appears only after the first beta build was published. If it still fails, run `grep '^Suites:' /etc/apt/sources.list.d/nubo.sources` and confirm the line says `resolute` or `resolute-beta` and nothing else.

**The channel flips back after an update of `nubo-archive`.**
The source file belongs to the `nubo-archive` package. Debian tools treat files in `/etc` as configuration and ask before replacing one you changed. If you answered "install the package maintainer's version", the file went back to stable. Run `sudo nubo-channel beta` again.

**The `nubo-channel` command is not found.**
It is installed to `/usr/sbin`. Use the full path `/usr/sbin/nubo-channel`, or install the package with `sudo apt install nubo-archive`.

## See also

- [How updates work](/updates/how-updates-work/)
- [Automatic updates](/updates/automatic-updates/)
- [Commands reference](/reference/commands/)
