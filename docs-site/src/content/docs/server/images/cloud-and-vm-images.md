---
title: Cloud and VM images
description: Build the Nubo OS Server qcow2, vhd and vmdk images and run them on KVM, Hyper-V and VMware.
sidebar:
  order: 10
---

**Applies to:** Server, Virtualization, Containers, Edge

`images/build-cloud.sh` makes a ready-to-boot disk image of Nubo OS Server. It takes Ubuntu's 26.04 server cloud image, adds the Nubo packages for the flavour you choose, and writes the image in three formats.

:::caution
The first builds of these images have not been tested. The image repository's own status table lists the cloud and VM image as untested. Treat your first run as debugging, and report problems to support@nubo.email.
:::

## What the script produces

| File | Format | Used by |
|---|---|---|
| `nubo-os-FLAVOUR-ARCH.qcow2` | QCOW2 | KVM, QEMU, libvirt, Proxmox, OpenStack |
| `nubo-os-FLAVOUR-ARCH.vhd` | VHD, dynamic | Hyper-V |
| `nubo-os-FLAVOUR-ARCH.vmdk` | VMDK | VMware |

`FLAVOUR` is `server`, `virt`, `containers` or `edge`. `ARCH` is `amd64` or `arm64`. The image has a virtual size of 10 GiB.

## Before you begin

- A Linux machine with root access and these packages: `qemu-utils` and `libguestfs-tools` (and `curl`).
- The Nubo `.deb` files in one directory: `nubo-archive`, `nubo-base`, `nubo-server-core`, plus `nubo-server-base`, `nubo-incus`, `nubo-podman` or `nubo-edge`, depending on the flavour. The script copies them into the image and installs them there.
- Network access to `archive.nubosuite.tech`, which serves Ubuntu's cloud image through Nubo Cumulus.
- About 10 GiB of free disk space per output format, plus the downloaded image.

## Steps

### 1. Build

```bash
sudo FLAVOUR=server images/build-cloud.sh DEBS_DIR OUT_DIR amd64
```

The arguments are the folder with the `.deb` files, the output folder, and the architecture (`amd64` or `arm64`; the default is the build machine's). `FLAVOUR` defaults to `server`.

The script:

1. Downloads `resolute-server-cloudimg-ARCH.img` from `https://archive.nubosuite.tech/cumulus-cloud/resolute/current/`.
2. Grows it to 10 GiB with `qemu-img resize`.
3. Uses `virt-customize` to copy the packages and `ci/use-cumulus.sh` in, point apt at Nubo Cumulus, install the flavour with `apt-get install --no-install-recommends`, run the firewall script, remove the temporary files, and truncate `/etc/machine-id`.
4. Converts the image to VHD (`qemu-img convert -O vpc -o subformat=dynamic`) and VMDK (`qemu-img convert -O vmdk`).

Because the packages are installed with `--no-install-recommends`, recommended extras such as `podman-compose` or QEMU are not in the image. Install them after the first boot if you need them.

### 2. Make a first-boot configuration

The image is Ubuntu's cloud image, so it needs a cloud-init configuration to create a user. See [cloud-init on Nubo images](/server/autoinstall/cloud-init/).

### 3. Run it

**KVM with libvirt**

```bash
sudo cp OUT_DIR/nubo-os-server-amd64.qcow2 /var/lib/libvirt/images/
sudo virt-install --name nubo-server --memory 2048 --vcpus 2 \
  --disk /var/lib/libvirt/images/nubo-os-server-amd64.qcow2 \
  --disk seed.iso,device=cdrom \
  --import --os-variant ubuntu24.04 --network network=default
```

`seed.iso` is the cloud-init seed. Pick an `--os-variant` that your `osinfo-query os` lists.

**Hyper-V.** Create a Generation 2 virtual machine with `nubo-os-server-amd64.vhd` as its disk. Attach the seed as a DVD drive. Generation 2 uses UEFI Secure Boot; the secure boot template may need to be set to "Microsoft UEFI Certificate Authority" for Ubuntu-based images. Not tested with Nubo.

**VMware.** Create a virtual machine with a custom configuration and use `nubo-os-server-amd64.vmdk` as an existing disk. Choose firmware UEFI. Attach the seed ISO. Not tested with Nubo.

arm64 images need an arm64 hypervisor or QEMU emulation.

## Verify

After boot, log in with your key and run:

```bash
cloud-init status
cat /etc/os-release | head -2
dpkg -l nubo-server-core
sudo ufw status
```

You should see cloud-init `done`, the name "Nubo OS Server", the package installed, and the firewall active with SSH allowed.

## Troubleshooting

**`virt-customize` fails with "libguestfs: error: ... supermin" or cannot read the kernel.** Cause: the build machine's kernel files are not readable by the current user. Fix: run with `sudo`, as above.

**`apt-get install` in the image cannot find a `.deb`.** Cause: the `DEBS_DIR` does not contain a file for each package. Fix: add the missing file. The glob uses the package name, `PACKAGE_*.deb`.

**Download of the base image fails.** Cause: Cumulus is not reachable. Fix: check `https://archive.nubosuite.tech/check`, then retry.

**The VM boots but you cannot log in.** Cause: no cloud-init seed, so no user. Fix: attach the seed; see [cloud-init on Nubo images](/server/autoinstall/cloud-init/).

**Hyper-V does not boot the VHD.** Cause: Generation 1 versus 2, or the secure boot template. Fix: use Generation 2 and check the template.

**Not enough space in the image.** Cause: 10 GiB is the default. Fix: resize the disk with your hypervisor before the first boot.

## See also

- [Raspberry Pi image](/server/images/raspberry-pi-image/)
- [Build your own image](/server/images/build-your-own-image/)
- [Choose a flavour](/server/flavours/)
