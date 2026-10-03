---
title: Your first login
description: What you see the first time you sign in, and what Nubo OS does in the background on the first boot.
sidebar:
  order: 50
---

**Applies to:** Desktop

The first time you start a freshly installed Nubo OS, a few things happen at once. This page explains what you see and what is going on behind it, so a slow first minute does not worry you.

## Before you begin

- You have finished [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/) or installed in a VM.
- A network connection is recommended. Several first-boot jobs need it and retry on the next boot if they cannot reach the network.

## Steps

1. **Start the computer.** You see Nubo's boot screen while the system starts.
2. **Choose your user.** The login screen shows your name and a profile picture. If you did not choose a picture, you get the default: the Nubo mark on an orange disc. Nubo sets it at first boot.
3. **Enter your password** in the password field. The eye icon at the right of the field shows or hides what you type.

   ![The login screen with a user name and a password field](../../../../assets/screens/login.jpg)

4. **Wait for the desktop.** You arrive on a clean desktop with the wallpaper, a clock widget, the top bar and the floating dock. Desktop icons are off by default.
5. **Let the first boot finish.** Within a few minutes, with a network:
   - Apps arrive from Flathub: Firefox, LocalSend, Newelle, Collabora Office, Shortwave, Spotify (on x86 only) and VLC. Each is installed one at a time. An app that does not exist for your CPU is skipped.
   - Ubuntu's store snaps, the Firefox snap, the Thunderbird snap and LibreOffice are removed.
   - Ubuntu's Pro client is removed.
6. **Check for the Nubo account sign-in.** If the network is up, the account setup runs once and installs the sign-in connector. Early access. After that, the login screen can offer a "Nubo Account" sign-in using a code you approve from a phone or another computer. <!-- verify label -->

:::note
Your first sign-in with a password always works. Nubo account sign-in is early access and has not been approved end to end with a real account.
:::

## What the first boot does

Two system services run on the first boot, until each has succeeded once:

| Service | What it does | Marker file |
|---|---|---|
| `nubo-first-boot` | Removes the Ubuntu snaps Nubo does not use, removes the Ubuntu Pro client, adds Flathub, sets the default profile picture, removes LibreOffice and installs the Flathub apps. | `/var/lib/nubo/first-boot-done` |
| `nubo-account-setup` | Prepares the Nubo account sign-in. | `/var/lib/nubo/account-setup-done` |

If the network is missing, a job exits and tries again the next time the computer starts. Neither service runs from the installation media or the live session.

Two helpers start with every session: `nubo-session-helper`, which keeps older apps in step with the light or dark choice, and `nubo-app-stubs`, which draws the grey launchers. `nubo-notify-agent` keeps messaging apps ready to deliver notifications.

## Verify

Open a terminal and check the markers:

```bash
ls /var/lib/nubo/
```

When `first-boot-done` is present, the first boot has finished. Open the app grid and check that Firefox and the other apps are there.

To read what the first boot did:

```bash
journalctl -u nubo-first-boot
```

## Troubleshooting

- **No Firefox, no Collabora Office.** The apps come from Flathub. Without a network the job retries on the next boot. Connect, restart, and wait a few minutes. See [Apps not opening](/desktop/troubleshooting/apps-not-opening/).
- **The first boot seems stuck.** It can take a while on a slow network. Run `journalctl -u nubo-first-boot -f` to watch it.
- **Wrong password.** See [Login problems](/desktop/troubleshooting/login-problems/).
- **No "Nubo Account" option at the login screen.** The setup needs network access to `mail.nubo.email`, and it retries on each boot. If it never appears, sign in with your password. See [Login problems](/desktop/troubleshooting/login-problems/).
- **Spotify is missing on an Arm computer.** Spotify only exists for x86, so the first boot skips it.

## See also

- [A tour of your first day](/desktop/get-started/first-day-tour/)
- [What the installer does](/desktop/get-started/what-the-installer-does/)
- [Account](/desktop/account/)
