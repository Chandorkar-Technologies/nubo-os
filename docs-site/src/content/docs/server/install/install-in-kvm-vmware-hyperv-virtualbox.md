---
title: Install in KVM, VMware, Hyper-V or VirtualBox
description: The virtual machine settings that matter when installing Nubo OS Server in KVM, VMware, Hyper-V or VirtualBox.
sidebar:
  order: 40
---

**Applies to:** Server, Virtualization, Containers, Edge

The installer image works like any other UEFI Linux installer, so most hypervisors need only a few settings. This page lists what to set in four common hypervisors. The installer itself is the same everywhere: see [Installer screens explained](/server/install/installer-screens-explained/).

:::note
The steps here use each hypervisor's standard features. We have not recorded a tested run of Nubo OS Server on every product listed. Menu names change between versions, so treat the names as pointers.
:::

## Before you begin

- A verified image whose CPU type matches the hypervisor's CPU (amd64 on Intel and AMD hosts, arm64 on Apple silicon or Arm hosts). See [Choose an image](/server/install/choose-an-image/).
- The hypervisor installed and working.
- Settings you can use as a starting point for a test server: 2 virtual CPUs, 2 GB of memory, a 20 GB disk. These are our suggestions, not measured requirements.

## Settings that apply everywhere

| Setting | Value | Why |
|---|---|---|
| Firmware | UEFI (not BIOS) | The images are built for UEFI. |
| Disk bus | VirtIO, SCSI or SATA | All work with the Ubuntu kernel. Prefer the paravirtual one for your hypervisor. |
| Network | NAT, or bridged if you want other machines to reach the server | The installer needs a network that reaches archive.nubosuite.tech. |
| CD/DVD | The ISO attached | Remove it after the install. |

## KVM and QEMU with libvirt (Linux hosts)

With `virt-install`, one command creates the VM and starts the installer. Replace the paths and sizes with yours:

```bash
virt-install \
  --name nubo-server \
  --memory 2048 --vcpus 2 \
  --disk size=20 \
  --cdrom ~/Downloads/nubo-os-server-0.8.0-beta3-amd64.iso \
  --os-variant ubuntu24.04 \
  --boot uefi
```

If your `osinfo-query os` lists a newer Ubuntu entry, use it instead of `ubuntu24.04`. With `virt-manager`, tick **Customize configuration before install** and set **Firmware** to UEFI on the Overview page. To use the arm64 image on an Arm host, create an `aarch64` VM; it always uses UEFI.

After the install, detach the ISO: `virsh change-media nubo-server sda --eject` (use the device name that `virsh domblklist nubo-server` shows for the CD).

## VMware Workstation, Fusion and ESXi

1. Create a new VM and choose the ISO as the installer disc.
2. Set the guest OS to Linux, Ubuntu 64-bit (or the nearest Ubuntu entry).
3. Open the VM's advanced options and set the firmware type to **UEFI**. Leave Secure Boot off unless you have confirmed it boots. <!-- verify label -->
4. Choose NAT or bridged networking.
5. Start the VM and run the installer.
6. After the install, edit the CD/DVD device and untick **Connect at power on**, or remove the device.

VMware Fusion on Apple silicon runs arm64 guests, so use the arm64 image there.

## Hyper-V (Windows hosts)

1. In Hyper-V Manager choose **New > Virtual Machine** and select **Generation 2**. Generation 2 uses UEFI.
2. Assign at least 2 GB of memory and turn off dynamic memory for the first install.
3. Connect the network adapter to a virtual switch (for example the Default Switch).
4. Create a virtual hard disk of 20 GB or more.
5. Attach the ISO as the installation option.
6. Before you start the VM, open **Settings > Security**. If the VM does not boot, change **Template** to **Microsoft UEFI Certificate Authority**, or clear **Enable Secure Boot**. Generation 2 VMs use a Windows-only Secure Boot template by default, which rejects most Linux boot loaders. <!-- verify label -->
7. Start the VM and connect to it.
8. After the install, remove the ISO under **Settings > SCSI Controller > DVD Drive** by choosing **None**.

Hyper-V runs amd64 guests on Intel and AMD hosts, and arm64 guests on Windows on Arm.

## VirtualBox

1. Click **New**. Give the VM a name, select the ISO, and set the type to Linux, version Ubuntu (64-bit). Tick **Skip Unattended Installation**, because the Nubo installer has its own answer file. <!-- verify label -->
2. Set 2048 MB of memory and 2 CPUs.
3. Create a virtual disk of 20 GB or more.
4. Before you start, open **Settings > System > Motherboard** and tick **Enable EFI (special OSes only)**. <!-- verify label -->
5. Under **Settings > Network**, use NAT, or Bridged Adapter if other machines must reach the server. With NAT you need a port-forwarding rule to SSH in from the host.
6. Start the VM and run the installer.
7. After the install, open **Settings > Storage** and remove the ISO from the optical drive.

VirtualBox on Apple silicon runs arm64 guests only, so use the arm64 image there. <!-- verify label: VirtualBox 7.1 arm64 host support -->

## Verify

Log in on the VM's console and run:

```bash
grep PRETTY_NAME /etc/os-release
ls /sys/firmware/efi
```

The first command prints `PRETTY_NAME="Nubo OS Server 1"`. If the second command lists files, the VM booted in UEFI mode.

Continue with the [first boot checklist](/server/install/first-boot-checklist/).

## Troubleshooting

**The VM boots to a firmware shell or says "no bootable device".** The ISO is not attached, or the boot order has the empty disk first. Attach the ISO and put the CD/DVD first.

**The VM boots the installer again after the install.** The ISO is still attached. Remove it as described for your hypervisor.

**A Hyper-V VM shows a security or signature error.** Change the Secure Boot template as described in step 6 of the Hyper-V section.

**No network in the installer.** Check the virtual switch or NAT setting. On the Network screen the interface should show an IPv4 address.

**The installer seems stuck on a black screen in VirtualBox or VMware.** The Nubo images hide most boot messages. Wait a minute before you power the VM off.

## See also

- [Install in UTM on a Mac](/server/install/install-in-utm/)
- [Images](/server/images/) for cloud and VM disk images (qcow2, vhd, vmdk)
- [Ubuntu Server: virtualization](https://ubuntu.com/server/docs/how-to/virtualisation/)
