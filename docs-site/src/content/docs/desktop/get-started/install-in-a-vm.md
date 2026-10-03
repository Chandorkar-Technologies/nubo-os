---
title: Install Nubo OS in a virtual machine
description: Run Nubo OS in UTM on an Apple silicon Mac, in VirtualBox, or with QEMU.
sidebar:
  order: 30
---

**Applies to:** Desktop

A virtual machine (VM) is the safest way to try a full install. This guide covers UTM on a Mac with Apple silicon, VirtualBox, and QEMU. The Nubo project itself develops and tests the desktop in VMs: its test machines use a virtual UEFI computer with a virtual disk and a virtio display, running under QEMU on Proxmox.

:::caution
The per-tool settings below are recommendations. The repository confirms the virtio display setup used by the project's own test machines. It does not contain step-by-step instructions for UTM or VirtualBox, and the menu names in those tools change between versions. Treat the settings as a starting point and check each tool's own documentation.
:::

## Before you begin

- The Nubo OS desktop ISO that matches your CPU. A Mac with Apple silicon needs the **arm64** image. An Intel or AMD computer needs **amd64**. The arm64 desktop image has not been tested on real hardware. See [Write the installer to a USB stick](/desktop/get-started/write-the-installer-usb/) for where to get the file.
- Free disk space for the virtual disk. Ubuntu Desktop lists 25 GB as its requirement, so use that as a floor. <!-- verify size -->
- Memory to give the VM. Ubuntu Desktop lists 6 GB. The project's own screenshots were taken in a VM with 4 GB, but that is not a recommendation.
- A host network connection, because the first boot downloads apps.

## Display settings that matter

These settings apply to every tool.

- **Use a virtio display device.** The project's test VMs use virtio graphics (`--vga virtio` in `vm/proxmox-create-install-test-vm.sh`). It lets the guest change resolution cleanly.
- **Use UEFI, not legacy BIOS.** The project's test VMs use UEFI (OVMF).
- **Let the guest resize with the window.** Nubo OS installs `spice-vdagent`, the helper that lets the guest follow the host window size, in the `nubo-desktop` package.
- **Give the guest 3D acceleration if the tool offers it.** The glass effect is blur drawn by the shell. A VM without acceleration may flicker or run slowly. See [Display flickers or resizes in a VM](/desktop/troubleshooting/display-flickers-or-resizes-in-a-vm/).

## UTM on a Mac with Apple silicon

1. Install UTM from <https://mac.getutm.app>.
2. Choose to create a new virtual machine, then **Virtualize**, then **Linux**. Virtualize runs the arm64 image at close to native speed. Emulate is for other CPU types and is much slower.
3. Choose the Nubo OS arm64 ISO as the boot image.
4. Give it memory and CPU cores. Give it at least 4 CPU cores if your Mac has them, and 6 GB of RAM or more.
5. Give it a disk of 25 GB or more.
6. Before the first start, open the VM's settings, then Display, and choose a virtio display device. Pick one with GPU acceleration if the list has it, such as `virtio-gpu-gl-pci`. <!-- verify label -->
7. In the same Display settings, turn on **Dynamic Resolution**, which lets the guest follow the window size. <!-- verify label -->
8. Start the VM and follow [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/) from step 3. The installer is the same.
9. After the install, remove the ISO from the VM's drive list.

## VirtualBox

1. Install VirtualBox on an Intel or AMD host. VirtualBox does not run arm64 guests on Apple silicon, so use UTM there.
2. Create a new VM, choose the type Linux and Ubuntu (64-bit).
3. Choose the Nubo OS amd64 ISO. If VirtualBox offers unattended installation, turn it off. Nubo's installer expects you to answer its screens.
4. Give it memory, CPU cores and a disk.
5. In the VM's settings, open Display and turn on 3D acceleration. Choose the VMSVGA graphics controller. <!-- verify label -->
6. In the System settings, turn on **Enable EFI**. <!-- verify label -->
7. Start the VM and follow [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/).

## QEMU

QEMU gives you the same setup the project uses. A command line for an amd64 guest:

```bash
qemu-img create -f qcow2 nubo.qcow2 30G
qemu-system-x86_64 \
  -machine q35 -accel kvm -cpu host -smp 4 -m 6G \
  -bios /usr/share/ovmf/OVMF.fd \
  -drive file=nubo.qcow2,if=virtio \
  -cdrom nubo-os-1-amd64.iso -boot d \
  -device virtio-vga \
  -display gtk \
  -nic user,model=virtio-net-pci
```

The path to the OVMF firmware differs between systems. This command has not been run against the Nubo image, so adjust it for your host. For an arm64 guest on an arm64 host, use `qemu-system-aarch64` with `-machine virt`, UEFI firmware for arm64, and `virtio-gpu-pci`.

## Verify

1. The installer reaches the Nubo OS screens.
2. After install and restart, the login screen appears at the size of the window.
3. Resizing the VM window changes the desktop resolution without flicker.

## Troubleshooting

- **The screen flickers, or the window size jumps back.** See [Display flickers or resizes in a VM](/desktop/troubleshooting/display-flickers-or-resizes-in-a-vm/).
- **The VM boots to a firmware shell.** The ISO was not picked up. Check the boot order, and make sure UEFI mode matches the image's CPU.
- **Everything is slow.** Check that the VM uses hardware virtualization (KVM, Hypervisor.framework or similar), and that the image matches the host CPU.
- **No network.** Check the network adapter type. A NAT adapter is the simplest. See [Wi-Fi and network problems](/desktop/troubleshooting/wifi-and-network/).
- **Copy and paste between host and guest does not work.** This relies on `spice-vdagent` and on the tool's clipboard sharing option. Check the tool's settings.

## See also

- [Try Nubo OS from a USB stick](/desktop/get-started/try-from-usb/)
- [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/)
- [Display flickers or resizes in a VM](/desktop/troubleshooting/display-flickers-or-resizes-in-a-vm/)
