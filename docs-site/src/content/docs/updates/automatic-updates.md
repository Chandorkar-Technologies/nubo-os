---
title: Automatic updates
description: Which updates Nubo OS installs on its own, how to check it, and how to turn it off.
sidebar:
  order: 40
---

**Applies to:** Desktop, Server, Virtualization, Containers, Edge

Nubo OS uses Ubuntu's unattended upgrades to install some updates without asking. The `nubo-archive` package ships the settings, so they apply to every edition.

## What installs automatically

The file `/etc/apt/apt.conf.d/52-nubo-unattended.conf` sets:

| Setting | Value | Meaning |
|---|---|---|
| `APT::Periodic::Update-Package-Lists` | `1` | Refresh the package lists once a day |
| `APT::Periodic::Unattended-Upgrade` | `1` | Run unattended upgrades once a day |
| `Unattended-Upgrade::Automatic-Reboot` | `false` | Never reboot by itself |

and allows packages from these origins:

| Origin pattern | What it covers |
|---|---|
| `origin=Ubuntu,codename=resolute-security` | Ubuntu security updates |
| `origin=Ubuntu,codename=resolute-updates` | Ubuntu's regular updates |
| `origin=Nubo,codename=resolute` | Nubo packages from the **stable** channel |

The beta channel is not in the list. Its codename is `resolute-beta`, which does not match, so beta packages are never installed automatically. If you switch to beta with `nubo-channel`, you install new Nubo builds yourself. See [Channels: stable and beta](/updates/channels-stable-and-beta/).

Because the automatic reboot is off, a kernel or library update may need a restart before it takes effect. The updates are installed; the running system changes after you restart.

## Which edition has what

- **Server and Edge.** The packages `nubo-server-base` (Server, Virtualization and Containers) and `nubo-edge` (Edge) depend on `unattended-upgrades`, so the service is always present. See [Editions comparison](/reference/editions-comparison/).
- **Desktop.** The `nubo-desktop` package does not list `unattended-upgrades` as a dependency. The settings above apply wherever the Ubuntu package is installed. For everything else, the desktop uses its software tool. Open the Nubo Store and check the updates page. <!-- verify label -->

:::note
Whether the desktop installation has the `unattended-upgrades` package by default was not confirmed from the repository. Use the verification steps below on your machine to find out.
:::

## Before you begin

- A terminal on the machine (on the desktop, the Terminal app).
- Administrator rights (`sudo`).

## Check that automatic updates are on

1. See whether the package is installed and the timers are active:

   ```bash
   apt-cache policy unattended-upgrades
   systemctl list-timers apt-daily.timer apt-daily-upgrade.timer
   ```

2. Read the effective settings:

   ```bash
   apt-config dump | grep -E 'Periodic|Unattended-Upgrade::(Automatic-Reboot|Origins-Pattern)'
   ```

3. Run a test without installing anything:

   ```bash
   sudo unattended-upgrade --dry-run --debug
   ```

   The output lists the origins it allows and the packages it would upgrade.

## Turn automatic updates off

Create a small file of your own that comes later in alphabetical order than `52-nubo-unattended.conf`, so your value wins and package updates never overwrite it:

```bash title="/etc/apt/apt.conf.d/60-my-updates.conf"
APT::Periodic::Unattended-Upgrade "0";
```

Do not edit `52-nubo-unattended.conf` itself. It belongs to the `nubo-archive` package and may be replaced when that package updates.

## Turn automatic reboots on

Servers sometimes should restart themselves at a quiet time. Add to your own file:

```bash title="/etc/apt/apt.conf.d/60-my-updates.conf"
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "03:30";
```

The option names are Ubuntu's. See the [Ubuntu Server documentation](https://ubuntu.com/server/docs) for the full list.

## Verify

```bash
apt-config dump | grep Periodic
tail -n 20 /var/log/unattended-upgrades/unattended-upgrades.log
```

The first command shows your values. The log shows what the last run installed, and the line `Allowed origins are` lists the three origins above.

## Troubleshooting

**Updates are not installing on a server.**
Run `sudo unattended-upgrade --dry-run --debug`. If a package shows `blacklisted` or `not allowed origin`, its source is not in the list above, for example a third-party repository. Third-party sources are never installed automatically unless you add their origin to your own file.

**A Nubo package is not updating.**
Check the channel with `sudo nubo-channel`. A package on beta is not installed automatically.

**The log file does not exist.**
The service has not run yet (it runs once a day), or the package is not installed. Check with `apt-cache policy unattended-upgrades`.

**The machine did not restart after a kernel update.**
Automatic reboots are off by default. Restart yourself, or use the option above. On servers, `needrestart` (part of `nubo-server-base`) tells you which services need a restart after an update.

## See also

- [How updates work](/updates/how-updates-work/)
- [Channels: stable and beta](/updates/channels-stable-and-beta/)
- [Ubuntu Server documentation](https://ubuntu.com/server/docs): automatic updates
