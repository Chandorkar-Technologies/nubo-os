---
title: Collect logs for support
description: Gather the system information and logs that support needs to diagnose a desktop problem.
sidebar:
  order: 100
---

**Applies to:** Desktop

When you write to support@nubo.email, a short description and a few logs let someone find your problem quickly. This page shows how to gather them into one folder. Nothing is sent anywhere by these commands. You choose what to share.

:::caution
Logs can contain your user name, computer name, network names and file names. Read the files before you send them, and delete any line you do not want to share. Never share passwords or keys.
:::

## Before you begin

- A terminal on the affected machine. If the desktop does not start, use a text console (<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F3</kbd>).
- If possible, reproduce the problem first, then collect the logs right away, so the logs show it.

## Steps

### 1. Make a folder

```bash
mkdir -p ~/nubo-logs && cd ~/nubo-logs
```

### 2. Record the version and channel

```bash
cat /usr/lib/os-release > os-release.txt
nubo-channel > channel.txt
dpkg -l 'nubo-*' > nubo-packages.txt
uname -a > kernel.txt
```

### 3. Record the hardware

```bash
lscpu > cpu.txt
free -h > memory.txt
df -h > disk.txt
lspci -nnk > pci.txt
lsusb > usb.txt
```

If you are in a virtual machine, also note which tool and version you use, for example UTM, VirtualBox or QEMU, and the host system.

### 4. Save the system log of this boot

```bash
journalctl -b --no-pager > boot.log
journalctl -b -p warning --no-pager > boot-warnings.log
```

If the problem happened on an earlier boot, for example a crash, use `-b -1`:

```bash
journalctl -b -1 --no-pager > previous-boot.log
```

### 5. Save the logs of the Nubo parts

```bash
journalctl -u nubo-first-boot --no-pager > first-boot.log
journalctl -u nubo-account-setup --no-pager > account-setup.log
journalctl --user -u nubo-notify-agent --no-pager > notify-agent.log
journalctl --user -u nubo-session-helper --no-pager > session-helper.log
journalctl --user -u nubo-app-stubs --no-pager > app-stubs.log
ls -l /var/lib/nubo/ > nubo-markers.txt
```

### 6. Save the desktop shell state

```bash
gnome-extensions list --enabled > extensions-enabled.txt
gnome-extensions list > extensions-all.txt
journalctl -b /usr/bin/gnome-shell --no-pager > gnome-shell.log
```

### 7. Save package and app details

```bash
apt-cache policy nubo-desktop nubo-archive > apt-policy.txt
flatpak list > flatpaks.txt
flatpak remotes > flatpak-remotes.txt
```

### 8. Check the network

```bash
nmcli device status > network.txt
curl -sI https://archive.nubosuite.tech/check > nubo-check.txt
```

### 9. Pack the folder

```bash
cd ~ && tar czf nubo-logs.tar.gz nubo-logs
ls -lh nubo-logs.tar.gz
```

### 10. Send it

Write to **support@nubo.email** with:

- What you did, what you expected, and what happened.
- The time it happened, roughly.
- The file `nubo-logs.tar.gz`, or the specific files that matter.

If the file is too large, tell support and offer to share it another way.

## Verify

Unpack the archive and check that it contains the files and that they are not empty:

```bash
tar tzf ~/nubo-logs.tar.gz
```

Open `os-release.txt` and `nubo-packages.txt`. They should list "Nubo OS 1" and your package versions.

## Troubleshooting

- **`journalctl` shows "No journal files were found".** The journal may not be saved across restarts, or you lack permission. Run the command with `sudo` for system units.
- **`gnome-extensions` reports it cannot connect.** Run it inside your desktop session, not from a text console or over SSH.
- **`nubo-channel` is not found.** Your system may not have the `nubo-archive` package. Mention that in your message.
- **A log is very long.** Send the last part, for example `journalctl -b --no-pager | tail -n 500 > boot-tail.log`.
- **The machine does not start at all.** Boot the live session from the USB stick and gather what you can. See [Boot problems](/desktop/troubleshooting/boot-problems/).

## See also

- [Getting help](/start/getting-help/)
- [Troubleshooting](/desktop/troubleshooting/)
