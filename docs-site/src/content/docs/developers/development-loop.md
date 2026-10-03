---
title: Development loop
description: Build the Nubo OS packages and install them in an arm64 Ubuntu virtual machine from a Mac, using vm/sync-and-build.sh.
sidebar:
  order: 20
---

Nubo OS packages must be built on Linux. The repository contains icon sources whose file names differ only by case, and macOS drops one of each pair without warning. So the loop is: edit on your Mac, copy the tree into a Linux virtual machine, build there, install there, and look at the result on the VM's desktop.

The script that does this is `vm/sync-and-build.sh`. This page shows how to use it with a local VM (for example one made in UTM on an Apple Silicon Mac). The repository has no UTM files; creating the VM is up to you. The script itself only needs an address it can reach over SSH.

## Before you begin

You need:

- A Mac with `ssh` and `rsync` (both ship with macOS).
- An arm64 Ubuntu 26.04 desktop VM. The packages are built for the VM's own CPU, so an arm64 VM on an Apple Silicon Mac builds arm64 packages. `vm/provision-desktop.sh` turns a fresh Ubuntu cloud-image VM into a desktop development machine; run it inside the VM with `sudo bash provision-desktop.sh`. It installs `ubuntu-desktop-minimal`, the QEMU guest agent and the build tools, and it switches on automatic login and turns off the screen lock. Those two settings are for development VMs only.
- A user in the VM (the script's default is `nubo`) that you can reach with an SSH key. The script runs `ssh -o BatchMode=yes`, so it can never ask for a password.
- `sudo` in the VM that does not ask for a password. The script runs `sudo apt-get build-dep` and `sudo apt-get install` over SSH with no terminal, so a password prompt would stop it. <!-- verify: passwordless sudo is inferred from BatchMode and the missing -t flag; confirm on your VM -->
- `rsync` inside the VM as well.
- The VM's IP address. A desktop VM takes its address from DHCP, so it can change between starts. Check it again if the script cannot connect.

## Steps

1. Find the VM's address. In the VM, run:

   ```bash
   hostname -I
   ```

2. From the repository root on your Mac, run the script with that address:

   ```bash
   VM_IP=192.0.2.10 vm/sync-and-build.sh
   ```

   Replace `192.0.2.10` with your VM's address. When `VM_IP` is given on the command line, the script treats the VM as local and ignores any `PVE_HOST` from your settings file.

3. The script runs three stages and prints a heading for each:

   | Stage | What happens |
   |---|---|
   | `==> Syncing sources` | `rsync -az --delete` copies the repository to `/home/nubo/nubo-os/` in the VM. It leaves out `.git/`, `.DS_Store`, `/build/`, `/out/`, the vendored Colloid sources, `debian/.debhelper/`, the per-package build folders `debian/nubo-*/` and `debian/files`. |
   | `==> Building in VM` | Runs `vendor/fetch.sh`, then `sudo apt-get build-dep -y ./`, then `dpkg-buildpackage -us -uc -b` (showing the last 25 lines). It moves the finished `nubo-*_*.deb` files into `out/` and deletes the `.buildinfo` and `.changes` files. |
   | `==> Installing in VM` | Installs every package in `out/` except the server ones, with `--reinstall --allow-downgrades` and `--force-confnew`. |

4. To build without installing, add `--no-install`:

   ```bash
   VM_IP=192.0.2.10 vm/sync-and-build.sh --no-install
   ```

5. Log out and back in on the VM to see shell extension or theme changes. Some changes (a new gsettings default, for example) only apply to a new session or a new user.

## Settings the script reads

| Variable | Default | Meaning |
|---|---|---|
| `VM_IP` | none | Address of a local VM. If set on the command line, `PVE_HOST` is ignored. |
| `PVE_HOST` | empty | Proxmox host such as `root@host`. When set, the script asks the host for the VM's address with `qm guest cmd`. |
| `VM_USER` | `nubo` | User to log in as. |
| `VMID` | `301` | Proxmox VM id, used only with `PVE_HOST`. |
| `REMOTE_DIR` | `/home/$VM_USER/nubo-os` | Where the tree is copied to. |

The script also reads `~/.config/nubo-os/env` (or `$XDG_CONFIG_HOME/nubo-os/env`) if it exists, so you can keep these settings out of your shell history. Without `VM_IP` or `PVE_HOST` it exits with "set PVE_HOST (Proxmox) or VM_IP (local VM)".

## Why the script skips the server packages

The server packages replace the desktop identity. `nubo-server-core` conflicts with `nubo-branding`, which `nubo-desktop` depends on, so a machine is either a desktop or a server, never both. The install step filters the package list with `grep -v` on `nubo-server`, `nubo-edge`, `nubo-podman` and `nubo-incus`. They are still built, and they land in `out/` for use when you test server images (see [Building the server images](/developers/building-server-images/)).

## Tips

- **Take a snapshot before you start** and another when the VM is in a known good state. The README names the snapshots used on the Proxmox VM (`desktop_clean`, `nubo_v0_2`, `nubo_v0_3`); the same habit works in UTM.
- **Rebuild only what you need.** There is no partial build in the script. `dpkg-buildpackage` rebuilds all packages every time, and `vendor/fetch.sh` skips downloads that already match their pin.
- **Screenshots.** `vm/screenshot.sh`, `vm/click.sh`, `vm/keys.sh`, `vm/capture-set.sh` and `vm/capture-boot.sh` read the VM's display from the hypervisor with `qm`, so they work with Proxmox, not with UTM. In UTM, take screenshots in the VM or from the UTM window.
- **Proxmox VMs.** `vm/proxmox-create-dev-vm.sh` creates VM 301 (`nubo-os-dev`) on a private bridge, and `vm/proxmox-create-install-test-vm.sh` creates VM 302 (`nubo-os-install-test`), an empty machine for the installer image.
- **Do not copy the development settings.** Automatic login and no screen lock exist so unattended screenshots work. Never ship them.

## Verify

After the script finishes, check in the VM:

```bash
ls -lh ~/nubo-os/out/
dpkg -l 'nubo-*' | awk '/^ii/ {print $2, $3}'
```

You should see the `.deb` files and the version from `debian/changelog` on every installed Nubo package. Then check the desktop:

```bash
cat /etc/os-release | head -3
```

The first line should read `PRETTY_NAME="Nubo OS 1"`.

## Troubleshooting

- **"Could not find the VM address".** This message comes from the Proxmox path. For a local VM, set `VM_IP`.
- **`Permission denied (publickey)`.** The script cannot use a password. Copy your key with `ssh-copy-id nubo@<address>`.
- **The script hangs or stops at `apt-get build-dep`.** `sudo` is asking for a password it cannot receive. Allow passwordless `sudo` for the user in the VM.
- **`build-dep` cannot find packages.** Enable source repositories in the VM, then run `sudo apt-get update`. The packages named in `Build-Depends` in `debian/control` come from Ubuntu 26.04.
- **A checksum mismatch from `vendor/fetch.sh`.** A pinned download changed upstream. Do not edit the checksum to make it pass; see [Building the packages](/developers/building-packages/).
- **The install stage reports conflicts.** You installed a server package by hand in a desktop VM. Remove it, or go back to a clean snapshot.

## See also

- [Building the packages](/developers/building-packages/)
- [Testing checklist](/developers/testing-checklist/)
