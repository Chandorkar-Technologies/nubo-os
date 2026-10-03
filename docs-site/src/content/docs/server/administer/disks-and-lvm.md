---
title: Disks and LVM
description: Read the installer's default disk layout on Nubo OS Server, check free space, and grow the root volume with LVM.
sidebar:
  order: 90
---

**Applies to:** Server, Virtualization, Containers, Edge

The installer's default disk layout uses LVM (Logical Volume Manager) for the root file system. LVM puts a flexible layer between the disk and the file system: you can grow a volume while the system runs, add a second disk to the same pool, and take snapshots. Nubo does not change how LVM works. This page shows how to read the layout and the two jobs you will do most: growing the root volume and adding a disk.

## The installer's default layout

With the guided storage option and "Set up this disk as an LVM group" selected, the installer creates three things on the disk: <!-- verify label: sizes and names from the installer screens -->

| Piece | Size | Mounted at | Why it is separate |
|---|---|---|---|
| EFI system partition | 1 GB | `/boot/efi` | UEFI firmware reads the boot loader from here. |
| Boot partition | 2 GB | `/boot` | Kernels and the boot files stay outside LVM (and outside encryption, if you chose it). |
| LVM physical volume | the rest of the disk | (a volume group) | Holds the root logical volume. |

The volume group holds a logical volume for `/`. With Ubuntu's installer the group and volume are normally named `ubuntu-vg` and `ubuntu-lv`. Check the real names on your machine. <!-- verify label -->

The installer may leave part of the volume group unused. In that case the root volume is smaller than the disk, and the rest is free to allocate. You can find out below.

## Before you begin

- Logged in as a user with `sudo`.
- A recent backup if the machine holds data. Growing a volume is safe in normal use, but a mistake in partitioning can lose data. See [Backups](/server/administer/backups/).

## Steps

### Read the layout

```bash
lsblk -f
findmnt /
df -h /
sudo pvs
sudo vgs
sudo lvs
```

`lsblk -f` shows disks, partitions, file system types and mount points. `pvs`, `vgs` and `lvs` show physical volumes, volume groups and logical volumes. In `vgs`, the `VFree` column is unallocated space in the group.

### Grow the root volume into free space

If `vgs` shows free space in `VFree` and you want the root file system to use it:

```bash
sudo lvextend -r -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
```

Use your volume's path from `lvs` (or `findmnt /`). The `-r` option also grows the file system, so no second command is needed. This works for ext4, which is Ubuntu's default.

### Add a second disk to the pool

Say a new empty disk shows up as `/dev/vdb` in `lsblk`. Check that it is the right and empty one.

```bash
sudo pvcreate /dev/vdb
sudo vgextend ubuntu-vg /dev/vdb
sudo lvextend -r -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
```

### Use a new disk for data instead

```bash
sudo mkfs.ext4 /dev/vdb
sudo mkdir -p /srv/data
sudo blkid /dev/vdb
```

Copy the UUID that `blkid` prints and add a line to `/etc/fstab`:

```text title="/etc/fstab"
UUID=your-uuid-here  /srv/data  ext4  defaults  0  2
```

Test the entry without rebooting, because a bad line in `fstab` can stop the machine from booting:

```bash
sudo mount -a
findmnt /srv/data
```

### Grow a virtual disk after enlarging it in the hypervisor

1. Enlarge the virtual disk in the hypervisor, then check that the guest sees it: `lsblk`.
2. Grow the partition that holds LVM. First install the tool (`sudo apt install cloud-guest-utils`). Then, for example if the LVM partition is number 3 on `/dev/vda`:

   ```bash
   sudo growpart /dev/vda 3
   sudo pvresize /dev/vda3
   sudo lvextend -r -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
   ```

   Use the device and partition number that `lsblk` shows for the LVM partition. Under the default layout the first two partitions are the EFI and boot partitions, so LVM is normally the third. <!-- verify label -->

## Verify

```bash
df -h /
sudo lvs
```

`df -h /` shows the new size, and `lvs` shows the larger logical volume.

## Troubleshooting

**`lvextend` says `Insufficient free space`.** The volume group has no free extents. Add a disk (`vgextend`), or enlarge the physical volume first (`pvresize`).

**`growpart` says `NOCHANGE`.** The partition already fills the disk, or the guest has not noticed the bigger disk. Run `lsblk` to check, and `echo 1 | sudo tee /sys/class/block/vda/device/rescan` for a virtual SCSI disk (the device name differs).

**`mount -a` prints an error.** Fix the line in `/etc/fstab` before you reboot. Check that the UUID is correct and the folder exists.

**The root volume is much smaller than the disk.** That is the unallocated space in the volume group. `vgs` shows it in `VFree`. Grow the volume as shown above.

**You need to shrink a volume.** Shrinking is possible for ext4 but riskier and needs the file system unmounted. Back up first and follow Ubuntu's LVM documentation.

**LVM names in this page do not match your machine.** Use the paths printed by `sudo lvs` instead.

## See also

- [Installer screens explained](/server/install/installer-screens-explained/)
- [Disk encryption](/server/security/disk-encryption/)
- [Ubuntu Server: logical volume management](https://ubuntu.com/server/docs/explanation/storage/about-lvm/)
