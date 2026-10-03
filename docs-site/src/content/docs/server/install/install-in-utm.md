---
title: Install in UTM on a Mac
description: Install Nubo OS Server in a virtual machine on an Apple silicon Mac with UTM and the arm64 image.
sidebar:
  order: 20
---

**Applies to:** Server, Virtualization, Containers, Edge

UTM is a free virtual machine app for macOS. On a Mac with Apple silicon (M1 or later) it can run an arm64 guest at close to native speed, which makes it a convenient way to try Nubo OS Server. This how-to creates a VM, runs the installer and boots the installed system.

## Before you begin

- A Mac with Apple silicon and a current version of macOS.
- UTM, installed from https://mac.getutm.app or the Mac App Store.
- The **arm64** Nubo OS Server image, downloaded and verified. See [Choose an image](/server/install/choose-an-image/). An amd64 image does not run at full speed on Apple silicon, so use arm64.
- Free disk space for the virtual disk. We suggest 20 GB as a starting point for a test server. This is our suggestion, not a measured minimum.

## Steps

The names of UTM's buttons and fields can change between UTM versions. The wording below is what UTM showed when this page was written. <!-- verify label -->

1. Open UTM and choose **Create a New Virtual Machine**. <!-- verify label -->
2. Choose **Virtualize**, not Emulate. Virtualize uses the Mac's own CPU and is much faster. <!-- verify label -->
3. Choose **Linux**.
4. Under **Boot ISO Image**, click **Browse** and select the `nubo-os-server-<version>-arm64.iso` file (or the edition you chose). Leave the other boxes on this screen unchecked. <!-- verify label -->
5. Set the hardware. These are starting points we suggest for a test server:
   - **Memory:** 2048 MB. Give 4096 MB or more for the Virtualization edition if you plan to start virtual machines inside it.
   - **CPU cores:** 2.
6. Set the storage size. 20 GB is enough to try the installer and install a few packages.
7. Skip the shared directory. You can add one later.
8. Give the VM a name such as `nubo-server` and click **Save**.
9. Before starting it, open the VM's settings (the slider icon) and select **Network**. Make sure the mode is **Shared Network**. In this mode the Mac gives the VM an address through NAT, so the VM can reach the internet and the Mac can reach the VM. <!-- verify label -->
10. Start the VM with the play button. A boot menu appears with "Install Nubo OS Server" (the title changes with the edition). Press <kbd>Enter</kbd>.
11. Work through the installer. The screens are explained in [Installer screens explained](/server/install/installer-screens-explained/). In short:
    - Language and keyboard: choose yours.
    - Network: accept the automatic (DHCP) address on the single network interface.
    - Storage: accept the default guided layout. Leave "Set up this disk as an LVM group" selected. <!-- verify label -->
    - Profile: create your user and a server name.
    - SSH: select the option to install the OpenSSH server. <!-- verify label -->
12. When the installer shows "Installation complete", **do not press Reboot yet.** The VM would boot from the ISO again unless you remove it first.
13. Eject the ISO. In the UTM window, click the **CD/DVD** icon in the toolbar and choose to eject or clear the image. If you cannot find it, shut the VM down, open its settings, select the CD/DVD drive and use **Clear**. <!-- verify label -->
14. Reboot the VM. It starts from its virtual disk.

## Verify

1. At the login prompt, the banner reads `Nubo OS Server 1`. Log in with the user you created.
2. Check the system identity:

   ```bash
   grep PRETTY_NAME /etc/os-release
   ```

   ```text
   PRETTY_NAME="Nubo OS Server 1"
   ```

3. Find the VM's address:

   ```bash
   ip -br address
   ```

4. From Terminal on the Mac, connect to it over SSH (use your user name and the address from the previous step):

   ```bash
   ssh your-user@192.168.64.5
   ```

   The address in this example is only an illustration. Use the one your VM shows.

Then continue with the [first boot checklist](/server/install/first-boot-checklist/).

## Troubleshooting

**The VM boots into the installer again after the reboot.** The ISO is still attached. Shut the VM down, clear the CD/DVD drive in its settings, and start it again.

**Black screen after you press Enter on the boot menu.** The installer is starting; the Nubo images hide most boot messages. Wait a minute. If the screen stays black, open the VM's display settings and check that the display device is the default one that UTM chose for Linux.

**"Virtualize" is not offered, or the VM is very slow.** Virtualize needs an arm64 image on an Apple silicon Mac. If you chose an amd64 image, UTM can only emulate it, which is slow. Download the arm64 image.

**The VM has no network in the installer.** On the network screen, check that the interface shows an IPv4 address. If not, shut down, set the network mode to **Shared Network**, and start again.

**You cannot reach the VM from the Mac over SSH.** Check that you installed the OpenSSH server on the SSH screen and that the VM has an address (`ip -br address`). With the default firewall, SSH is allowed and everything else is closed. See [Firewall with ufw](/server/administer/firewall-ufw/).

## See also

- [Installer screens explained](/server/install/installer-screens-explained/)
- [First boot checklist](/server/install/first-boot-checklist/)
- [Install in KVM, VMware, Hyper-V or VirtualBox](/server/install/install-in-kvm-vmware-hyperv-virtualbox/)
- [UTM documentation](https://docs.getutm.app)
