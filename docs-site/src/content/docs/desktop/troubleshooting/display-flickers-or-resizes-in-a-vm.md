---
title: Display flickers or resizes in a VM
description: Fix flicker, tearing and wrong resolution when you run the Nubo OS desktop inside a virtual machine.
sidebar:
  order: 10
---

**Applies to:** Desktop

The Nubo OS desktop draws a frosted-glass blur on the top bar, dock, menus, overview and lock screen. Blur needs the graphics stack to work well. In a virtual machine, a poorly matched virtual graphics card is the most common cause of flicker, tearing, a wrong resolution, or a screen that snaps back after you resize the window.

## Before you begin

- You can open a terminal in the guest. If the screen is unusable, press <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F3</kbd> for a text console and sign in there, then use <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F2</kbd> to return. The key to return can vary. <!-- verify -->
- Shut down the VM when you need to change its settings in the host tool.

## Steps

### 1. Use a virtio display

In the VM's settings on the host, set the display to a **virtio** graphics device. The Nubo project's own test machines use virtio graphics. Settings differ between UTM, VirtualBox and QEMU, so see [Install Nubo OS in a virtual machine](/desktop/get-started/install-in-a-vm/).

### 2. Use UEFI

Check that the VM boots in UEFI mode. The project's test machines use UEFI.

### 3. Turn on automatic resizing

- In UTM, open the VM's Display settings and turn on **Dynamic Resolution**. <!-- verify label -->
- In VirtualBox, turn on 3D acceleration in Display, and install the guest additions if the host tool asks. <!-- verify label -->
- In QEMU or virt-manager, use a SPICE display with the clipboard and resizing enabled.

Nubo OS includes `spice-vdagent`, the guest helper that makes the guest follow the window size. Check that it is running:

```bash
systemctl status spice-vdagentd
```

### 4. Give the guest a fixed resolution while you test

In Settings, open Displays and choose a resolution that matches your host window, then resize the window slowly. If a change makes the screen flicker, wait a second and change it back.

### 5. Turn the blur off to test

If the flicker comes from the blur, turn the extension off for a moment. The blur comes from the `blur-my-shell@aunetx` extension.

```bash
gnome-extensions disable blur-my-shell@aunetx
```

Sign out and back in, or check right away. To turn it on again:

```bash
gnome-extensions enable blur-my-shell@aunetx
```

If the flicker stops when the blur is off, your virtual graphics card is not good enough for it. Go back to step 1 and try another display device, or leave the blur off in that VM.

## Verify

1. Move the VM window or resize it. The desktop follows the window and does not flicker or jump.
2. The top bar, dock and overview show without tearing.
3. The command `gnome-extensions list --enabled` shows the blur extension if you turned it back on.

## Troubleshooting

- **The resolution is stuck at a small size.** The guest helper may not be running. Run `systemctl status spice-vdagentd` and restart the VM. In UTM, make sure Dynamic Resolution is on for the display. <!-- verify label -->
- **The screen is black after boot.** Wait a minute, then try a different virtual display device. If you still see nothing, see [Boot problems](/desktop/troubleshooting/boot-problems/).
- **Everything is slow, not only flickering.** The VM may be running without hardware virtualization, or the guest CPU type may not match the host. Check the host tool's settings.
- **The pointer is offset or invisible.** Install or enable the guest helper and the tool's pointer integration. Use a USB tablet device for the pointer if the tool offers it. <!-- verify -->
- **The flicker comes back after an update.** An update may have reset an extension setting. See [Reset desktop settings](/desktop/troubleshooting/reset-desktop-settings/).

## See also

- [Install Nubo OS in a virtual machine](/desktop/get-started/install-in-a-vm/)
- [Collect logs for support](/desktop/troubleshooting/collect-logs-for-support/)
