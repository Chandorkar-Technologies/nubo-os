---
title: Incus networks and storage
description: What the Nubo Incus preseed sets up (the nubobr0 bridge and the default storage pool) and how to change it.
sidebar:
  order: 60
---

**Applies to:** Virtualization

`nubo-incus-init` configures Incus from one file, the preseed. This page shows what is in it and how to change the network and storage afterwards.

## The preseed

The file is `/usr/share/nubo/incus-preseed.yaml`, installed by the `nubo-incus` package:

```yaml title="/usr/share/nubo/incus-preseed.yaml"
networks:
  - name: nubobr0
    type: bridge
    config:
      ipv4.address: auto
      ipv6.address: auto
storage_pools:
  - name: default
    driver: dir
profiles:
  - name: default
    devices:
      eth0: {name: eth0, network: nubobr0, type: nic}
      root: {path: /, pool: default, type: disk}
```

`nubo-incus-init` feeds it to `incus admin init --preseed`.

| Object | Name | Setting | Meaning |
|---|---|---|---|
| Network | `nubobr0` | type `bridge` | A managed bridge. Incus runs DHCP and DNS on it for the instances. |
| Network | `nubobr0` | `ipv4.address: auto`, `ipv6.address: auto` | Incus picks a free private subnet for each family. |
| Storage pool | `default` | driver `dir` | Instances are stored as plain directories on the host's file system. |
| Profile | `default` | `eth0` | A network card on `nubobr0`. |
| Profile | `default` | `root` | The root disk, on pool `default`. |

Note that `ipv4.address: auto` also turns on NAT for the bridge, which is Incus's default for managed bridges. See the Incus network documentation for the full option list.

## Change the network

You do not edit the preseed file after setup. The preseed is applied once. Change the live configuration with `incus network`:

```bash
incus network show nubobr0
incus network set nubobr0 ipv4.address 10.20.0.1/24
incus network set nubobr0 ipv6.address none
```

Running instances may need to renew their DHCP lease or restart to pick up a new subnet.

To give instances addresses on your physical network instead of NAT, create a second network or profile that bridges to your host interface. This depends on your network and is covered in the Incus documentation on [bridge networks](https://linuxcontainers.org/incus/docs/main/reference/network_bridge/) and [network interfaces](https://linuxcontainers.org/incus/docs/main/reference/devices_nic/).

## Change the storage

The `default` pool uses `dir`. To add a ZFS pool (the ZFS tools are installed by `nubo-incus`):

```bash
incus storage create fast zfs size=30GiB
```

Without a `source`, Incus creates a loop-file backed pool of the given size. To use a disk or partition, pass `source=/dev/DEVICE`, which destroys the data on it. Launch an instance on the new pool:

```bash
incus launch images:ubuntu/24.04 c2 --storage fast
```

To make the new pool the default for future instances, edit the default profile and change the `pool` of the `root` device:

```bash
incus profile device set default root pool=fast
```

Existing instances stay on their pool. Moving them is covered in the Incus storage documentation.

## Change what the init command does

If you want a different first setup on many machines, copy the preseed, edit the copy, and apply it yourself:

```bash
incus admin init --preseed < my-preseed.yaml
```

The preseed is applied on top of an Incus that has not been initialised. If you run it on a host that already has the objects, Incus may report that they exist.

## Verify

```bash
incus network list
incus storage list
incus profile show default
```

Check that the network and the pool you expect are listed, and that the default profile points at them.

## Troubleshooting

**`incus network set` fails with "not found".** Cause: the network name is wrong or the setup never ran. Fix: `incus network list`; run `sudo nubo-incus-init` if it is empty.

**ZFS pool creation fails.** Cause: the ZFS kernel module is missing or the source device is in use. Fix: `sudo modprobe zfs`, and check the device with `lsblk`.

**Instances cannot reach the network after a change.** Cause: `ufw` or the new subnet. Fix: see the firewall note in the [quick start](/server/flavours/virtualization-quick-start/).

## See also

- [Virtualization with Incus](/server/flavours/virtualization-incus/)
- [Containers or virtual machines](/server/flavours/virtualization-containers-vs-vms/)
- [Incus storage documentation](https://linuxcontainers.org/incus/docs/main/explanation/storage/)
