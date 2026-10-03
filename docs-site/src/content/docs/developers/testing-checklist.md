---
title: Testing checklist
description: The manual checks to run before a Nubo OS release, with concrete commands for packages, the desktop install, updates, the server flavours and the archive.
sidebar:
  order: 140
---

There is no automated test suite for the installed system yet. Before a build goes to the beta channel, and again before a beta is promoted to stable, someone runs these checks by hand. Tick them off for each release and keep notes of failures. The checks use only commands that exist on the systems; where a result depends on the machine, the text says what to look for rather than an exact output.

## Before you begin

- Fresh virtual machines, or snapshots you can roll back to: one desktop, and one per server flavour you ship (`server`, `virt`, `containers`, `edge`).
- Test on both CPUs when you ship both: amd64 and arm64. `nubo-search` is the only package built per CPU.
- The packages or images of the build under test.
- Use a clean snapshot for each install test. Never test an install on a machine that already has Nubo packages from another build.

## 1. Packages

1. Build and install on the development VM (see [Development loop](/developers/development-loop/)). The install step must finish without questions and without conffile prompts.
2. List the versions:

   ```bash
   dpkg -l 'nubo-*' | awk '/^ii/ {print $2, $3}'
   ```

   Every package shows the version from `debian/changelog`.
3. **Upgrade test.** Install the previous release from the archive on a clean desktop, then upgrade to the new one:

   ```bash
   sudo apt update
   sudo apt install --only-upgrade nubo-desktop
   ```

   Look for prompts about changed configuration files. There should be none.
4. **Remove test (desktop VM only).** Remove `nubo-branding` and confirm Ubuntu's files return:

   ```bash
   sudo apt remove nubo-branding
   ls /usr/lib/os-release.ubuntu 2>/dev/null || echo "diversion removed"
   head -2 /etc/os-release
   ```

   <!-- verify: expected os-release output after removal on a stock Ubuntu desktop -->
5. **Conflict test.** On a desktop VM, try `sudo apt install nubo-server-core`. It must refuse, because it conflicts with `nubo-branding`.

## 2. Desktop install

Boot the desktop ISO (see [Building the desktop ISO](/developers/building-the-desktop-iso/)) in a VM.

1. The boot menu entries read "Try or Install Nubo OS" and "Nubo OS (safe graphics)".
2. The live session shows the Nubo desktop (dark theme, top bar, dock).
3. The installer's pages are interactive and show the Nubo product name. The title text comes from the installer app, which needs the Nubo-built snap; note if it still says "Ubuntu".
4. Install to the virtual disk and reboot.
5. After first login, check the identity:

   ```bash
   cat /etc/os-release | head -3
   ls /var/tmp/nubo 2>/dev/null || echo "installer copy removed"
   ```

   The first line reads `PRETTY_NAME="Nubo OS 1"`. The installer's late commands delete `/var/tmp/nubo`.
6. **First boot.** The cleanup runs on each boot until it finishes once. With a network connection:

   ```bash
   cat /var/lib/nubo/first-boot-done
   journalctl -b -u nubo-first-boot --no-pager | tail -20
   flatpak list --system --app
   snap list 2>/dev/null
   ```

   The marker file holds a timestamp. The log lines start with `nubo-first-boot:`. The Flathub apps from the script's `FLATPAKS` list are installed (an app that does not exist for the CPU, such as Spotify on arm64, is skipped). `firefox`, `thunderbird` and the other listed snaps are gone. Repeat once with the network off: the log should say it will try again next boot.
7. **Desktop pieces.** Look at each and note anything broken:
   - the top bar with the Nubo logo and "Nubo OS 1", and the Activities overview when you click it;
   - the dock and the app grid, with the folders "Utilities", "Accessories" and "More apps";
   - a grey icon in the grid: click one, and confirm the app downloads and opens;
   - the widgets on the desktop;
   - the notification centre, and a test notification:

     ```bash
     notify-send "Test" "Hello"
     systemctl --user status nubo-notify-agent --no-pager
     ```

   - Nubo Search opens with <kbd>Super</kbd>+<kbd>Space</kbd>, or from a terminal:

     ```bash
     nubo-search toggle
     ```

   - the default profile picture exists: `ls -l ~/.face`;
   - light and dark switch: change the system style and confirm the theme follows;
   - the Nubo account sign-in entry on the login screen (early access; note the result).
8. Check nothing on the media is still mounted as a source: `mountpoint -q /cdrom || echo "no media mounted"`.

## 3. Updates and channels

On the new desktop and on a server:

```bash
sudo nubo-channel
grep -r URIs /etc/apt/sources.list.d/
sudo apt update
apt-cache policy nubo-base
sudo nubo-channel beta
sudo apt update
sudo nubo-channel stable
```

- `nubo-channel` with no argument prints `stable` or `beta`.
- `ubuntu.sources` points at `mirror+https://archive.nubosuite.tech/cumulus/mirrors.txt` (`cumulus-arm` on arm64).
- `nubo.sources` points at `https://archive.nubosuite.tech` with suite `resolute`, signed by `/usr/share/keyrings/nubo-archive-keyring.gpg`.
- `apt update` reports no signature errors.
- **Opt out of Cumulus:** `sudo touch /etc/nubo/no-cumulus`, then `sudo apt install --reinstall nubo-archive`, and check that `ubuntu.sources` points at Ubuntu again. Remove the marker and reinstall to go back.
- **Automatic updates** on a machine that has unattended-upgrades:

  ```bash
  sudo unattended-upgrade --dry-run --debug 2>&1 | grep -i "allowed origins"
  ```

  The allowed origins include `origin=Nubo,codename=resolute`.

## 4. Privacy settings

```bash
systemctl is-enabled motd-news.timer whoopsie.service apport.service
cat /etc/update-manager/release-upgrades
chronyc sources 2>/dev/null | head
```

The masked units print `masked`. `release-upgrades` holds `Prompt=never`. The time sources include `time.cloudflare.com`. For a fuller check, run `tools/audit-ubuntu-traces.sh` on the machine and read what it lists.

## 5. Server flavours

For each flavour you ship, install from its ISO in a fresh VM (see [Building the server images](/developers/building-server-images/)).

**Installer.** Only the language, keyboard, network, storage, user and SSH screens appear. The Ubuntu Pro, featured snaps, mirror and update screens do not. The menu title matches the flavour.

**Common checks (all four):**

```bash
head -2 /etc/os-release
sudo ufw status verbose
sudo sshd -T | grep -E '^(permitrootlogin|maxauthtries|logingracetime|x11forwarding)'
sysctl kernel.kptr_restrict kernel.dmesg_restrict net.ipv4.tcp_syncookies
systemctl is-active chrony apparmor
snap version 2>/dev/null || echo "no snapd"
```

- `PRETTY_NAME="Nubo OS Server 1"`.
- ufw is active, denies incoming by default and allows OpenSSH.
- `permitrootlogin no`, `maxauthtries 4`, `logingracetime 30`, `x11forwarding no`.
- `kernel.kptr_restrict = 2`, `kernel.dmesg_restrict = 1`.
- `chrony` and `apparmor` are active, and snapd is absent.
- Log in over SSH: the message of the day says "Nubo OS Server" and shows docs and support addresses.

**Per flavour:**

| Flavour | Check |
|---|---|
| Server | `systemctl is-active fail2ban`; `dpkg -l unattended-upgrades needrestart htop vim-tiny` |
| Edge | `fail2ban` and `needrestart` are not installed; `unattended-upgrades` is |
| Containers | `sudo nubo-podman-init`, then `podman run --rm docker.io/library/hello-world` as your own user; `podman info` works rootless |
| Virtualization | `sudo nubo-incus-init`, log out and in, then `incus list`; check the bridge with `incus network list` (expect `nubobr0`) and the pool with `incus storage list` (expect `default`); on amd64 `which qemu-system-x86_64`, on arm64 `which qemu-system-aarch64` |

Also test the upgrade path from the previous flavour image, if one exists, and `sudo apt install nubo-incus` on a plain server to confirm adding a flavour later works.

:::note
The flavours were added in `0.8.0~beta3` and have not been tested on hardware. Record the hardware you used.
:::

## 6. Archive and Cumulus

After a publish:

```bash
curl -fsSL https://archive.nubosuite.tech/suites/resolute-beta.list
curl -fsSL https://archive.nubosuite.tech/cumulus/mirrors.txt
curl -fsSI https://archive.nubosuite.tech/check
curl -fsSI https://archive.nubosuite.tech/iso/<version>/<image>.iso.sha256
```

Download an image and check it against its published checksum:

```bash
sha256sum -c <image>.iso.sha256
```

## 7. arm64

Repeat sections 1, 2 and 5 on an arm64 VM. For the desktop, confirm `nubo-search` is installed and opens, and that Spotify is skipped without errors. Until an arm64 CI runner exists, the arm64 `nubo-search` is uploaded by hand, so check its version too:

```bash
apt-cache policy nubo-search
```

## Verify

A release passes when every item above has a recorded result, every failure has an open issue or a fix, and the result of the upgrade test (section 1) shows no configuration prompts.

## Troubleshooting

- **The first-boot marker is missing.** The script retries each boot. Read `journalctl -b -u nubo-first-boot` for the reason, usually no network.
- **`snap list` still shows packages on the desktop.** Snapd stays on the desktop because the sign-in broker is a snap. Only the listed snaps are removed.
- **A grey icon does nothing.** Run `nubo-get <flathub-id>` in a terminal and read the error.
- **`ufw status` shows inactive.** The firewall script runs only on first install of `nubo-server-core`. Run `/usr/libexec/nubo/nubo-server-firewall` by hand and record the case.
- **A server test machine cannot install packages.** The installer needs a network (through Cumulus) to fetch dependencies.

## See also

- [Publishing releases](/developers/publishing-releases/)
- [Development loop](/developers/development-loop/)
