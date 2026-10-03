---
title: Raspberry Pi image
description: Build the Nubo OS Server image for Raspberry Pi 4 and 5 and write it to a card.
sidebar:
  order: 20
---

**Applies to:** Server, Virtualization, Containers, Edge

`images/build-pi.sh` builds an arm64 image for the Raspberry Pi. It starts from Ubuntu's preinstalled 26.04 server image for the Raspberry Pi, adds the Nubo packages for the flavour you choose, and compresses the result. The Edge flavour is the natural fit for a Pi, but all four flavours can be built.

:::caution
The script has not been run on a CI runner, and the image has not been tested on a Raspberry Pi. The image repository lists it as untested. A desktop variant for the Pi is not built; the script's own comment says it follows once the server image is proven.
:::

## Before you begin

- A Linux machine with root, and the packages `qemu-utils`, `libguestfs-tools`, `xz-utils` and `curl`.
- The Nubo `.deb` files (arm64, or `all` for the architecture-independent ones) in one folder: `nubo-archive`, `nubo-base`, `nubo-server-core`, plus `nubo-server-base`, `nubo-incus`, `nubo-podman` or `nubo-edge`, depending on the flavour. The Nubo server packages are architecture-independent.
- A Raspberry Pi 4 or 5, a microSD card or USB disk, and a card reader.
- About 10 GiB of free disk space for the unpacked image.

## Steps

### 1. Build

```bash
sudo FLAVOUR=edge images/build-pi.sh DEBS_DIR OUT_DIR
```

`FLAVOUR` is `server` (the default), `virt`, `containers` or `edge`. The script:

1. Downloads `ubuntu-26.04-preinstalled-server-arm64+raspi.img.xz` through Nubo Cumulus (`https://archive.nubosuite.tech/cumulus-images/releases/resolute/release/`) and unpacks it to `OUT_DIR/nubo-os-FLAVOUR-raspi.img`.
2. With `virt-customize`: copies in the packages, points apt at Nubo Cumulus (`ci/use-cumulus.sh`), installs the flavour packages without recommended extras, and removes the temporary files.
3. Compresses the image with `xz` to `OUT_DIR/nubo-os-FLAVOUR-raspi.img.xz`.

The Pi script does not run the firewall script by hand. The `nubo-server-core` package does it on first install, so the same closed-except-SSH firewall results.

### 2. Write it to the card

Unpack and write with a tool of your choice, such as the Raspberry Pi Imager's "Use custom" option, or on Linux:

```bash
xz -dk OUT_DIR/nubo-os-edge-raspi.img.xz
sudo dd if=OUT_DIR/nubo-os-edge-raspi.img of=/dev/DISK bs=4M conv=fsync status=progress
```

Check the device name with `lsblk` first. `dd` overwrites the disk without asking.

### 3. Add first-boot configuration

The base image is Ubuntu's Raspberry Pi image, which reads cloud-init configuration from the boot partition. Put your `user-data` there before the first boot. See [cloud-init on Nubo images](/server/autoinstall/cloud-init/) and [Prepare and provision an Edge device](/server/flavours/edge-prepare-and-provision/).

### 4. Boot

Insert the card, connect the network and power, and wait for the first boot to finish, which takes longer than later ones.

## Verify

```bash
ssh admin@ADDRESS
cat /etc/os-release | head -2
uname -m
dpkg -l nubo-server-core
```

Expect "Nubo OS Server", `aarch64`, and the package installed. Run `sudo ufw status` to confirm that the firewall is active.

## Troubleshooting

**The Pi does not boot.** Cause: an image problem, the card, or the Pi's firmware or boot order. Fix: try another card; update the Pi's boot firmware if needed; report the problem, since this image is untested on hardware.

**`virt-customize` fails.** Cause: it needs root and a readable kernel on the build host. Fix: run with `sudo`.

**No `.deb` found for a package.** Cause: `DEBS_DIR` lacks it. Fix: add it.

**You cannot find the Pi on the network.** Cause: no DHCP, or Wi-Fi without a configuration. Fix: use Ethernet for the first boot, or provide a `network-config` as described in Ubuntu's documentation for the Pi.

**SSH refuses root.** Cause: by design. Fix: use your own user.

**Not enough room.** Cause: the image size follows Ubuntu's image. Fix: the root partition grows to fill the card on the first boot, as in Ubuntu's image (check on your device).

## See also

- [Edge](/server/flavours/edge/)
- [Cloud and VM images](/server/images/cloud-and-vm-images/)
- [Build your own image](/server/images/build-your-own-image/)
