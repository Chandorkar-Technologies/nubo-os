---
title: Prepare and provision an Edge device
description: Build an Edge image, write it to a Raspberry Pi or boot it as a VM, and set up users and keys on first boot with cloud-init.
sidebar:
  order: 150
---

**Applies to:** Edge

This guide takes you from nothing to an Edge device that you can log in to with an SSH key. It uses the image scripts in the Nubo repository and cloud-init, which the base images inherit from Ubuntu. The Raspberry Pi and cloud images have not been built on a CI runner, so treat every step here as not yet tested on hardware.

:::caution[Planned]
Read-only root, atomic updates and fleet management are not built. This guide provisions each device on its own, by hand or with a seed file you write.
:::

## Before you begin

- A Linux build machine with root access, and the tools `qemu-utils`, `libguestfs-tools`, `xz-utils` and `curl`.
- The Nubo `.deb` files for your architecture in one directory. You get them by building the repository's packages, or from the Nubo archive at https://archive.nubosuite.tech. The image scripts need `nubo-archive`, `nubo-base`, `nubo-server-core` and `nubo-edge` (the file names start with the package name).
- For a Raspberry Pi: a Raspberry Pi 4 or 5, a microSD card or USB disk, and a way to write images to it.
- An SSH key pair on your computer (`ssh-keygen -t ed25519`).

## Steps

### 1. Build the image

For a Raspberry Pi:

```bash
sudo FLAVOUR=edge images/build-pi.sh DEBS_DIR OUT_DIR
```

This downloads Ubuntu's preinstalled Raspberry Pi image through Nubo Cumulus, adds the Nubo packages, and writes `OUT_DIR/nubo-os-edge-raspi.img.xz`.

For a cloud or virtual machine image:

```bash
sudo FLAVOUR=edge images/build-cloud.sh DEBS_DIR OUT_DIR amd64
```

This writes `nubo-os-edge-amd64.qcow2`, `.vhd` and `.vmdk` into `OUT_DIR`. More detail is on [Raspberry Pi image](/server/images/raspberry-pi-image/) and [Cloud and VM images](/server/images/cloud-and-vm-images/).

### 2. Write your first-boot configuration

The base images are Ubuntu's, so first-boot setup is done by cloud-init. See [cloud-init on Nubo images](/server/autoinstall/cloud-init/) for more. A minimal file that creates a user with your key and no password login:

```yaml title="user-data"
#cloud-config
hostname: edge-01
users:
  - name: admin
    groups: [sudo]
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: true
    ssh_authorized_keys:
      - ssh-ed25519 AAAA... you@example
ssh_pwauth: false
```

Replace the key with the contents of your public key file. `NOPASSWD` is a convenience on a device that nobody logs into at a keyboard; remove it if you prefer to type a password for `sudo` (then set a password hash instead of locking the account).

### 3. Hand the configuration to the device

**Raspberry Pi.** Ubuntu's Raspberry Pi images keep a small FAT partition (labelled `system-boot`) that you can open on your computer after writing the image. cloud-init reads a file named `user-data` there. Copy your file into that partition before the first boot. Check Ubuntu's Raspberry Pi documentation for the current layout.

**Virtual machine.** Make a seed disk with the NoCloud labels and attach it:

```bash
sudo apt install cloud-image-utils
printf 'instance-id: edge-01\nlocal-hostname: edge-01\n' > meta-data
cloud-localds seed.iso user-data meta-data
```

Attach `seed.iso` as a second disk, for example with `qemu-system-x86_64 ... -drive file=seed.iso,format=raw`.

### 4. Boot and log in

Power on the device. The first boot takes longer than later ones. Find its address on your router, then:

```bash
ssh admin@ADDRESS
```

## Verify

On the device:

```bash
cat /etc/os-release | head -3
sudo ufw status
systemctl is-active unattended-upgrades
cloud-init status
```

Expect "Nubo OS Server 1" as the name, `ufw` active with SSH allowed, and cloud-init `status: done`. If the unit `unattended-upgrades` shows inactive, check `apt-config dump | grep Unattended` to see the settings in `/etc/apt/apt.conf.d/52-nubo-unattended.conf`.

## Troubleshooting

**cannot log in, key refused.** Cause: user-data not read, so the user was not created. Fix: check `cloud-init status --long` from a console; on a Raspberry Pi look at `/var/log/cloud-init.log`.

**The image still has Ubuntu's default account.** Cause: the base images come from Ubuntu and keep their first-boot behaviour unless your seed changes it. Fix: check Ubuntu's documentation for the base image and override users in your `user-data`. Not yet tested with the Nubo images.

**`build-pi.sh` fails with a missing `.deb`.** Cause: `DEBS_DIR` does not contain a file for each required package. Fix: add the missing package and rerun.

**No network on a Pi.** Cause: Wi-Fi needs a network config. Fix: provide a `network-config` file next to `user-data` following Ubuntu's netplan format.

**You cannot SSH as root.** Cause: by design, `PermitRootLogin no`. Fix: use your user and `sudo`.

## See also

- [Edge](/server/flavours/edge/)
- [Update and recover an Edge device](/server/flavours/edge-update-and-recover/)
- [Build your own image](/server/images/build-your-own-image/)
