---
title: Troubleshooting the desktop
description: Find the page that fixes your problem, starting from what you see.
sidebar:
  order: 1
---

**Applies to:** Desktop

Find your symptom in the list. Each page has the likely causes, the fix, and a check that it worked.

## Symptoms

### The screen looks wrong

- The screen flickers, tears, or the size jumps back in a virtual machine: [Display flickers or resizes in a VM](/desktop/troubleshooting/display-flickers-or-resizes-in-a-vm/).
- The desktop is missing a clock or cards that you expect: [Widgets not showing](/desktop/troubleshooting/widgets-not-showing/).
- Settings look strange after you changed things, or a shortcut stopped working: [Reset desktop settings](/desktop/troubleshooting/reset-desktop-settings/).

### You cannot start or sign in

- The computer does not start, shows a black screen or boots the wrong system: [Boot problems](/desktop/troubleshooting/boot-problems/).
- The password is not accepted, the login screen loops, or "Nubo Account" is missing: [Login problems](/desktop/troubleshooting/login-problems/).

### Something does not work

- No sound from speakers or headphones: [No sound](/desktop/troubleshooting/no-sound/).
- No Wi-Fi, no internet, or downloads do not start: [Wi-Fi and network problems](/desktop/troubleshooting/wifi-and-network/).
- An app does not open, a grey icon does nothing, or Firefox is missing: [Apps not opening](/desktop/troubleshooting/apps-not-opening/).
- Messaging apps do not notify you when their window is closed: [Notifications missing](/desktop/troubleshooting/notifications-missing/).

### You need to ask for help

- [Collect logs for support](/desktop/troubleshooting/collect-logs-for-support/) shows how to gather the information support needs.

## Before you start

Three quick checks fix a surprising number of problems:

1. Restart the computer.
2. Check that you have a network connection. Several Nubo jobs wait for it and retry on the next boot.
3. Run `sudo apt update && sudo apt upgrade`, then restart.

## If nothing here helps

See [Getting help](/start/getting-help/). Support is at support@nubo.email.
