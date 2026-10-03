---
title: Nubo Store
description: Use the Nubo Store, Nubo OS's app store, to find, install, update and remove apps from Flathub.
sidebar:
  order: 15
---

**Applies to:** Desktop

The Nubo Store is the app store of Nubo OS. It is GNOME Software with a new name. The program is unchanged. Nubo OS replaces its launcher entry so it shows the name **Nubo Store** and the generic name **App Store**. It sits in the dock by default, between Reminders and Settings.

![The Nubo app grid and dock](../../../../assets/screens/grid1.jpg)

## What it can do

- Search and install apps from **Flathub**. Flathub is added for the whole computer at the first boot with a network connection.
- Show installed apps and remove them.
- Show updates for Flatpak apps and install them. See [Update apps](/desktop/apps/update-apps/).

The desktop depends on `gnome-software` and `gnome-software-plugin-flatpak`. Packages from Ubuntu's archive can also appear if PackageKit is installed, which the desktop recommends.

Ubuntu's own store, the Snap Store, is removed on the first boot. The desktop package conflicts with it.

:::caution[Planned]
A Nubo Store with its own cloud login is not built. The goal would be to sign in once, see "your apps", and restore them on a new machine as grey placeholders. A curated "Popular" page is also only a plan. Today the Nubo Store is plain GNOME Software over Flathub. See [Nubo Drive and backup](/desktop/account/nubo-drive-and-backup/) for other planned account features.
:::

## Before you begin

- An internet connection.
- Flathub must be added. It is added at first boot. If the computer was offline then, it is retried at the next boot. You can also add it by hand, see Troubleshooting.

## Install an app

1. Open **Nubo Store** from the dock or the app grid.
2. Use the search field and type the name of an app.
3. Open the result. Check the source shown for it. Flathub is the usual source. <!-- verify label -->
4. Choose **Install**. <!-- verify label -->
5. When the install finishes, choose **Open**, or find the app in the app grid.

## Remove an app

1. Open **Nubo Store** and go to the list of installed apps. <!-- verify label -->
2. Open the app and choose **Uninstall**. <!-- verify label -->

## Verify

- The app opens from the app grid.
- In a terminal, `flatpak list --app` shows apps installed from Flathub.

```bash
flatpak list --app --columns=application,origin
```

## Troubleshooting

**The Store shows no Flathub apps.** Flathub is probably not added. Run:

```bash
flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

then restart the Store. The command needs administrator rights, and the system will ask you for your password.

**An install fails with a network error.** Check your connection and try again.

**An app you expect is missing.** The app may not exist for your computer's processor. For example, Spotify exists only for x86 computers.

**You see an app from a "snap" source.** Nubo OS does not use snaps for apps. Choose the Flathub entry instead.

**The Store opens but the list is empty after a long time offline.** Close it and open it again, so it refreshes its catalogue.

## See also

- [Install and remove apps](/desktop/apps/install-and-remove-apps/)
- [Flatpak basics](/desktop/apps/flatpak-basics/)
- [Popular apps: click to download](/desktop/apps/popular-apps-click-to-download/)
