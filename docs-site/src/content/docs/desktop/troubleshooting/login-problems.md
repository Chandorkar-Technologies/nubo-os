---
title: Login problems
description: Fix a rejected password, a login screen that loops, or a missing Nubo Account option.
sidebar:
  order: 20
---

**Applies to:** Desktop

The login screen shows your name, your profile picture and a password field. If you cannot get past it, work through the causes below from the most common to the least.

![The login screen with a user name and a password field](../../../../assets/screens/login.jpg)

## Before you begin

- A keyboard. If your password has symbols, check the keyboard layout before you type.
- A second way to reach a terminal, if you need one: a text console with <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F3</kbd>.

## Steps

### The password is not accepted

1. Click the eye icon at the right of the password field to show what you type. Check for typing mistakes, Caps Lock and the wrong keyboard layout.
2. Remember that <kbd>Alt</kbd>+<kbd>Shift</kbd> switches the keyboard layout on Nubo OS. You may have switched by accident.
3. Try again slowly. If you still cannot sign in, restart and try once more.
4. If you have forgotten the password, you can reset it from a recovery shell. Hold <kbd>Shift</kbd> at start to open the boot menu, choose recovery mode and open a root shell. Then run `passwd your-user-name`. The exact recovery menu comes from Ubuntu. See Ubuntu's documentation. <!-- verify label -->

### The login screen comes back after you sign in

This is a login loop. Often it is a full disk, or a problem with a file in your home folder.

1. Press <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F3</kbd>, sign in at the text console and run:

   ```bash
   df -h /
   df -h /home
   ```

   If a disk shows 100% use, free some space by deleting large files.

2. Check the ownership of your home folder:

   ```bash
   ls -ld ~ ~/.Xauthority 2>/dev/null
   ```

   Your folder should belong to you. Fix it with `sudo chown -R "$USER:" ~` if it does not.

3. Read the log of the last attempt:

   ```bash
   journalctl -b -p warning --no-pager | tail -n 60
   ```

4. If a Nubo extension looks like the cause, turn it off from the text console and try again:

   ```bash
   gnome-extensions disable glass-widgets@peter-njoro.github.io
   ```

   Extensions are listed in `gsettings get org.gnome.shell enabled-extensions`.

### The "Nubo Account" option is missing

Nubo account sign-in is early access. It needs a first boot with network access. The setup service `nubo-account-setup` retries on each boot until it succeeds once. <!-- verify label -->

1. Connect to a network and restart. See [Wi-Fi and network problems](/desktop/troubleshooting/wifi-and-network/).
2. Wait a few minutes after the restart, then look at the log:

   ```bash
   journalctl -u nubo-account-setup
   ls /var/lib/nubo/
   ```

   When `account-setup-done` is present, the setup finished.
3. The setup reaches `mail.nubo.email`. If your network blocks it, the log says that Nubo SSO is not reachable.

In the meantime, sign in with your password. It always works.

### The Nubo Account code does not work

The login screen shows a QR code and a short code. You approve it from a phone or another computer. If it fails, make sure the other device has internet, and try again to get a fresh code. Sign-in has not been approved end to end with a real account yet, so report the problem to support@nubo.email.

## Verify

You sign in, the desktop loads, and it stays loaded after you wait one minute.

## Troubleshooting

- **Everything fails after a power cut.** The disk may need a check. Boot the live session from your USB stick and check the disk. See [Try Nubo OS from a USB stick](/desktop/get-started/try-from-usb/).
- **A black screen after the password.** The session may have crashed. See [Display flickers or resizes in a VM](/desktop/troubleshooting/display-flickers-or-resizes-in-a-vm/) if you are in a VM.
- **The desktop loads without the Nubo theme.** See [Reset desktop settings](/desktop/troubleshooting/reset-desktop-settings/).

## See also

- [Boot problems](/desktop/troubleshooting/boot-problems/)
- [Collect logs for support](/desktop/troubleshooting/collect-logs-for-support/)
