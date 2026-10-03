---
title: Virtualization quick start
description: Set up Incus on a Nubo OS Server, then launch a system container and a virtual machine.
sidebar:
  order: 50
---

**Applies to:** Virtualization

In this tutorial you set up Incus with Nubo's defaults, launch a system container and a virtual machine, run a command in each, and clean up. It takes about ten minutes plus image download time.

## Before you begin

- A Nubo OS Server with the Virtualization flavour. Either you installed the Virtualization ISO, or you ran `sudo apt install nubo-incus` (see [Add or change a flavour](/server/flavours/switch-flavour/)).
- A user with `sudo`.
- Internet access, because images download from the public Incus image server.
- For the virtual machine: hardware virtualization. Run `ls /dev/kvm`. If the file is missing, skip the virtual machine part.

## Step 1: set up Incus

```bash
sudo nubo-incus-init
```

The script applies `/usr/share/nubo/incus-preseed.yaml` and adds you to the `incus-admin` group. It prints:

```text
Added YOUR-NAME to incus-admin. Log out and in again.
Try: incus launch images:ubuntu/24.04 first
```

Log out and log back in (or open a new SSH session) so that your group membership updates. Check:

```bash
id -nG | tr ' ' '\n' | grep incus-admin
```

## Step 2: launch a container

```bash
incus launch images:ubuntu/24.04 first
```

The first launch downloads the image, which takes a while. When it finishes, list your instances:

```bash
incus list
```

You should see `first` with the state RUNNING, an IPv4 address from the `nubobr0` network, and the type CONTAINER.

Run a command inside it:

```bash
incus exec first -- cat /etc/os-release
```

Open a shell with `incus exec first -- bash`. Leave with `exit`.

## Step 3: launch a virtual machine

Add `--vm`:

```bash
incus launch images:ubuntu/24.04 vm1 --vm
```

A virtual machine needs a minute or more to boot and for its agent to start. Check with `incus list`; the type column says VIRTUAL-MACHINE. Once it has an address:

```bash
incus exec vm1 -- uname -r
```

If the command says the agent is not running yet, wait a little and retry.

## Step 4: stop and clean up

```bash
incus stop vm1
incus delete vm1
incus delete first --force
```

`--force` stops a running instance before deleting it.

## Verify

After step 1, these show the Nubo setup:

```bash
incus network list
incus storage list
incus profile show default
```

You should see a network `nubobr0`, a storage pool `default` with the `dir` driver, and a default profile with an `eth0` device on `nubobr0` and a `root` device on pool `default`.

## Troubleshooting

**`incus: permission denied` or cannot connect to the socket.** Cause: your shell does not have the `incus-admin` group yet. Fix: log out and in, or run `sudo incus ...` for a one-off check.

**`nubo-incus-init`: "Run with sudo."** Cause: the script needs root. Fix: `sudo nubo-incus-init`.

**The instance starts but has no IPv4 address, or cannot reach the internet.** Cause: `ufw` is active and closed to everything but SSH, which can block DHCP, DNS and forwarding on the bridge. Fix: the Incus documentation on firewalls describes rules for the bridge; with `ufw` they are along the lines of `sudo ufw allow in on nubobr0`, `sudo ufw route allow in on nubobr0` and `sudo ufw route allow out on nubobr0`. Not yet tested on Nubo OS: read the [Incus firewall guidance](https://linuxcontainers.org/incus/docs/main/howto/network_bridge_firewalld/) and decide for your network.

**The virtual machine fails to start.** Cause: no KVM, or QEMU missing. Fix: check `ls /dev/kvm`; on a virtual host enable nested virtualization; install `qemu-system-x86` or `qemu-system-arm`.

**Image download fails.** Cause: no route to the image server. Fix: check the network; try `incus remote list`.

## What you built

An Incus host with a bridged network and a storage pool, one container and one virtual machine, both reachable with `incus exec`.

## Next steps

- [Incus networks and storage](/server/flavours/virtualization-networks-and-storage/): change the subnet or add a ZFS pool.
- [Containers or virtual machines](/server/flavours/virtualization-containers-vs-vms/): decide which to use.
- [Incus documentation](https://linuxcontainers.org/incus/docs/main/): everything else, such as projects, profiles and backups.
