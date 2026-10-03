---
title: Update and recover an Edge device
description: How an Edge device updates itself today, how to pick the beta or stable channel, and what recovery tools do not exist yet.
sidebar:
  order: 160
---

**Applies to:** Edge, Server

An Edge device keeps itself up to date with unattended upgrades. This page describes what runs, how to check it, how to switch update channels, and how to handle a bad update. It also lists what Nubo does not offer yet, so that you do not plan around it.

## What updates automatically

`nubo-edge` depends on `unattended-upgrades`, and `nubo-archive` installs `/etc/apt/apt.conf.d/52-nubo-unattended.conf`. That file does the following:

- refreshes the package lists once a day (`APT::Periodic::Update-Package-Lists "1"`);
- runs unattended upgrades once a day (`APT::Periodic::Unattended-Upgrade "1"`);
- installs from three sources: Ubuntu's `-security` and `-updates` for the release, and the Nubo archive;
- does not reboot by itself (`Unattended-Upgrade::Automatic-Reboot "false"`).

Because there is no automatic reboot, a kernel update takes effect only after you restart. The Server flavour has `needrestart` to tell you; Edge does not, so check `/var/run/reboot-required`:

```bash
test -f /var/run/reboot-required && echo "reboot needed"
```

## Before you begin

- An Edge or Server machine you can reach with SSH and `sudo`.

## Steps

### Check that updates are working

```bash
systemctl list-timers 'apt-daily*'
sudo unattended-upgrade --dry-run --debug 2>&1 | tail -20
tail -20 /var/log/unattended-upgrades/unattended-upgrades.log
```

### Choose a channel

The Nubo archive has two channels: stable (`resolute`) and beta (`resolute-beta`). A machine follows stable unless you change it.

```bash
sudo nubo-channel          # shows the current channel
sudo nubo-channel beta     # follow beta
sudo nubo-channel stable   # back to stable
sudo apt upgrade
```

Do not point production devices at beta. Switching back to stable does not downgrade packages that you already took from beta. See [Updates](/updates/) for how channels work.

### Reboot at a time you choose

```bash
sudo reboot
```

If you want the device to reboot itself after updates, set `Unattended-Upgrade::Automatic-Reboot "true"` in your own file under `/etc/apt/apt.conf.d/` with a higher number than 52, for example `60-edge-reboot`. Nubo does not set this because an unexpected reboot may not suit the device. Not yet tested.

### Recover from a bad update

There is no automatic rollback. What you can do:

1. Look at what changed: `grep -E 'Install|Upgrade' /var/log/apt/history.log | tail`.
2. See which versions are available: `apt policy PACKAGE`.
3. Install the earlier version: `sudo apt install PACKAGE=VERSION`. The archive keeps what it still carries; an older version may no longer be available.
4. Hold it so it is not upgraded again: `sudo apt-mark hold PACKAGE`. Release it later with `unhold`.
5. If the device does not boot, boot from another medium (for a Raspberry Pi, a second SD card with the image), mount the root file system, and use `chroot` to repair it, or reflash the device and restore your data from backup.

:::caution[Planned]
These are not built: atomic updates, A/B system slots, automatic rollback after a failed boot, a read-only root, and fleet-wide staged rollouts. Until they exist, keep a backup of device data and keep your first-boot configuration (for example the cloud-init file) so that reflashing a device is quick.
:::

## Verify

```bash
sudo nubo-channel
apt policy nubo-edge
```

The channel prints `stable` or `beta`, and `apt policy` shows the candidate version coming from `archive.nubosuite.tech`.

## Troubleshooting

**No updates are installed.** Cause: the timers are off, or the device has no network. Fix: `systemctl list-timers 'apt-daily*'`; check that you can reach `archive.nubosuite.tech`.

**`nubo-channel`: "Run with sudo."** Cause: it needs root. Fix: `sudo nubo-channel ...`.

**A held-back package.** Cause: unattended upgrades do not install packages that need new dependencies removed or that are on hold. Fix: `sudo apt full-upgrade` once you have read the plan.

**Disk is full.** Cause: old kernels and downloaded packages. Fix: `sudo apt autoremove` and `sudo apt clean`.

## See also

- [Edge](/server/flavours/edge/)
- [Updates](/updates/)
- [Prepare and provision an Edge device](/server/flavours/edge-prepare-and-provision/)
