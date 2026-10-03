---
title: cloud-init on Nubo images
description: Use cloud-init to set users, keys, packages and files on the first boot of a Nubo OS Server cloud or VM image.
sidebar:
  order: 50
---

**Applies to:** Server, Virtualization, Containers, Edge

The cloud and VM images and the Raspberry Pi image are not made by the installer. They start from Ubuntu's own cloud or Raspberry Pi image, which already includes cloud-init, and Nubo adds its packages to that disk. So first-boot configuration is cloud-init, as on Ubuntu. Nubo does not change cloud-init. This page covers how to use it with Nubo's images and what to watch for.

:::note
The first builds of the Nubo cloud and Raspberry Pi images have not been tested. The cloud-init steps below are standard cloud-init and Ubuntu behaviour; they have not yet been tried on a Nubo image.
:::

## Before you begin

- A Nubo OS Server image: a `.qcow2`, `.vhd` or `.vmdk` from `images/build-cloud.sh`, or a Pi image from `images/build-pi.sh`. See [Server images](/server/images/).
- A way to attach a configuration: a seed ISO, your hypervisor's cloud-init support, or the Raspberry Pi boot partition.
- An SSH key.

## Steps

### 1. Write `user-data`

```yaml title="user-data"
#cloud-config
hostname: nubo-vm
users:
  - name: admin
    groups: [sudo]
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: true
    ssh_authorized_keys:
      - ssh-ed25519 AAAA... you@example
ssh_pwauth: false
package_update: true
packages:
  - tmux
```

Other modules (`write_files`, `runcmd`, `timezone`) work as in Ubuntu. See the [cloud-init documentation](https://docs.cloud-init.io/).

### 2. Write `meta-data`

```yaml title="meta-data"
instance-id: nubo-vm-01
local-hostname: nubo-vm
```

Change `instance-id` when you want cloud-init to run again for a new machine made from the same disk. cloud-init runs the first-boot modules once per instance ID.

### 3. Build the seed and attach it

For a local VM with the NoCloud source:

```bash
sudo apt install cloud-image-utils
cloud-localds seed.iso user-data meta-data
```

Attach `seed.iso` to the VM as a second disk (for KVM with libvirt, add it as a CD-ROM or disk; see [Cloud and VM images](/server/images/cloud-and-vm-images/)). On a public cloud or a hypervisor with its own cloud-init support, paste the `user-data` into the platform's field instead.

For a Raspberry Pi, put `user-data` on the boot partition as described in [Prepare and provision an Edge device](/server/flavours/edge-prepare-and-provision/).

### 4. Boot

On first boot cloud-init creates the user, installs the key and runs the other modules. This takes extra time on the first boot only.

## What Nubo's packages change for cloud-init

- **Root login stays off.** `nubo-server-core` sets `PermitRootLogin no` in `/etc/ssh/sshd_config.d/90-nubo-sshd.conf`. A `disable_root`-style setting in your `user-data` is not needed. Do not rely on logging in as root.
- **Password login.** The Nubo SSH drop-in does not turn off password login. Set `ssh_pwauth: false` in `user-data` once your key works, as above.
- **The firewall is closed except SSH.** If your `runcmd` starts a service that listens on another port, also run `ufw allow PORT/tcp`.
- **Packages come through Nubo Cumulus.** The image scripts point apt at Cumulus, so `package_update` and `packages` use it. If a Cumulus request fails, apt falls back to Ubuntu's servers.
- **The machine ID is empty at first boot.** `build-cloud.sh` truncates `/etc/machine-id`, so each clone gets its own ID on first boot.
- **Cloud images are 10 GiB.** `build-cloud.sh` resizes the image to 10 GiB virtual size. Grow it further with your hypervisor tools before the first boot; Ubuntu's cloud images grow the root file system on first boot.

## The autoinstall installer and cloud-init

The server ISO uses cloud-init only as the way the installer reads its answer file. That is a separate use; see [How Nubo uses autoinstall](/server/autoinstall/how-nubo-uses-autoinstall/).

## Verify

On the new machine:

```bash
cloud-init status --long
id admin
cat /etc/os-release | head -2
```

You should see `status: done`, your user, and "Nubo OS Server".

If you changed `package` lists: `dpkg -l tmux`.

## Troubleshooting

**`status: error` or the user does not exist.** Cause: a YAML error in `user-data`, or the seed was not found. Fix: `cloud-init schema --config-file user-data` on your machine, and `sudo cat /var/log/cloud-init.log` on the new one.

**It ran for an old configuration.** Cause: the same instance ID. Fix: change `instance-id`, or run `sudo cloud-init clean --logs` and reboot (this removes cloud-init's state, so use it on test machines).

**Cannot SSH in.** Cause: the key, the user name, or the firewall. Fix: use the console to see `cloud-init status`; check `sudo ufw status`.

**Packages fail to install.** Cause: no network at that moment, or Cumulus is unavailable. Fix: `sudo apt update` by hand; see `/var/log/cloud-init-output.log`.

## See also

- [Cloud and VM images](/server/images/cloud-and-vm-images/)
- [Edge](/server/flavours/edge/)
- [cloud-init documentation](https://docs.cloud-init.io/)
