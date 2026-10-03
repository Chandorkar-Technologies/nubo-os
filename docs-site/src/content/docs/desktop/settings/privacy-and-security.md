---
title: Privacy and security
description: Set the screen lock, control location and camera access, understand what Nubo OS turns off, and find disk encryption.
sidebar:
  order: 70
---

**Applies to:** Desktop

This page covers the settings that protect your computer and your data, and says what Nubo OS does and does not do on its own. It makes no promise of being secure; it describes what is there, so you can decide.

## Before you begin

- For anything that changes the system, you need an administrator account.
- Decide your lock timeout: how long until the screen locks after it goes off.

## Screen lock

1. Open [Settings](/desktop/settings/) and go to the privacy page, then the screen lock option. <!-- verify label -->
2. Turn on automatic screen lock and choose how long after the screen turns off it locks.
3. Choose whether notifications show on the lock screen.

To lock at any time, press <kbd>Super</kbd>+<kbd>L</kbd>, or use the lock button in the top row of [quick settings](/desktop/use/quick-settings/).

The lock screen background is the Golden Dunes wallpaper unless you change it. See [Wallpapers](/desktop/use/wallpapers/).

## Location

Some apps use your location, for example for weather. Nubo's desktop widget for the clock and weather has a setting, `weather-auto-location`, that is on by default; the Weather app has its own location handling. <!-- verify label: how the widget finds the place is not documented in the repo -->

1. Open the privacy page in Settings and look for location services. <!-- verify label -->
2. Switch it off if you do not want any app to know where you are.
3. To stop the widget's automatic location, run:

```bash
gsettings set org.gnome.shell.extensions.glass-widgets weather-auto-location false
```

See [Desktop widgets](/desktop/use/widgets/) for the full list of keys.

## Camera and microphone

GNOME shows an indicator in the top bar when an app uses the microphone or camera. Apps installed as Flatpaks from Flathub ask permission through the system's portals. You can review and change what each app may do in Settings, on the apps page. <!-- verify label -->

## Passwords and keys

Nubo OS uses the GNOME keyring to store passwords. The Passwords and Keys app (in the Utilities folder) lets you look at them. Your login password unlocks the keyring.

## What Nubo OS switches off

Compared with a stock Ubuntu desktop, Nubo OS removes or masks several things that contact Canonical or send reports. These facts are from the Nubo OS source:

- Crash reporting (`apport`, `whoopsie`) is removed or masked, and the Ubuntu usage reporting packages conflict with the desktop.
- The Ubuntu Pro client is removed at first boot.
- The "news" in the login message and the release upgrade prompt are off.
- Nubo Search has system information telemetry turned off in its settings.
- Time is set from `time.cloudflare.com` and `pool.ntp.org` rather than Ubuntu's time servers.

Some contacts remain. For example, the Nubo sign-in broker is a snap, so snapd stays on the desktop, and the installer asks a geolocation service for a time zone. Nubo documents the remaining list in its repository at `docs/ubuntu-endpoints.md`.

## Disk encryption

Disk encryption is chosen when you install, in Ubuntu's installer, which Nubo OS uses with its own branding. The screens stay interactive. Nubo does not add or remove encryption options of its own. Look at the storage step of the installer for what your version offers, and see Ubuntu's documentation on encrypting the disk: https://ubuntu.com/desktop/docs. <!-- verify label: encryption options in the installer have not been checked for Nubo -->

You cannot easily add full disk encryption to an installed system. If you need it, reinstall with it on, after you back up your data.

## Updates

Security updates for Nubo OS and the Ubuntu base arrive through the Nubo archive and are installed automatically. See [Updates](/updates/).

## Verify

1. Lock the screen with <kbd>Super</kbd>+<kbd>L</kbd>. You need your password to get back in.
2. Run `gsettings get org.gnome.desktop.screensaver lock-enabled` to see if automatic locking is on.
3. Open a call or recorder app. The top bar shows the microphone indicator.

## Troubleshooting

**The screen does not lock by itself.**
Cause: automatic lock is off or the timeout is long. Fix: turn it on in Settings.

**An app cannot use the camera.**
Cause: it is a Flatpak without permission, or the camera is blocked. Fix: review the app's permissions in Settings.

**The weather shows the wrong place.**
Cause: automatic location is imprecise. Fix: turn it off and choose the place in the Weather app. <!-- verify label -->

**I cannot find the encryption option after installing.**
Cause: it can only be set during install. Fix: reinstall with encryption on.

## See also

- [Notifications](/desktop/use/notifications/)
- [Desktop widgets](/desktop/use/widgets/)
- [Updates](/updates/)
- Ubuntu's documentation: https://ubuntu.com/desktop/docs
