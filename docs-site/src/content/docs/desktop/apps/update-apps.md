---
title: Update apps
description: Keep Flatpak apps up to date from the Nubo Store or the terminal, and see how this differs from system updates.
sidebar:
  order: 110
---

**Applies to:** Desktop

Apps from Flathub update separately from the operating system. Firefox as a package, Geary and the system itself update through apt, which is covered in [Updates](/updates/). This page covers Flatpak apps.

## What updates what

| Kind | Examples | How it updates |
|---|---|---|
| Flatpak apps | Collabora Office, VLC, Spotify, Shortwave, apps from grey icons | The Nubo Store or `flatpak update` |
| Packages | Geary, Videos, system parts, the Nubo packages | apt, and the automatic updates set up by `nubo-archive` |
| Web apps | YouTube, WhatsApp and other launchers | Nothing to update. They are websites. |

The `nubo-archive` package sets up automatic installs of Nubo and Ubuntu security updates for packages. Nothing in the Nubo configuration schedules Flatpak updates, so the Store's own behavior applies. <!-- verify: GNOME Software automatic update setting -->

## Before you begin

- An internet connection.
- For system installs (apps installed at first boot, such as Collabora Office, VLC and Spotify), the update asks for administrator rights.
- Apps downloaded from grey icons are user installs and update without them.

## Update from the Nubo Store

1. Open [Nubo Store](/desktop/apps/nubo-store/).
2. Go to the updates page. <!-- verify label -->
3. Choose to update all, or update one app.
4. Close the apps that are being updated, if the Store asks.

## Update from a terminal

```bash
flatpak update
```

It lists what will change and asks you to confirm. Add `-y` to confirm automatically. To update one app:

```bash
flatpak update org.videolan.VLC
```

To also clean up runtimes that no app needs:

```bash
flatpak uninstall --unused
```

## Update the Firefox package and other packages

```bash
sudo apt update
sudo apt upgrade
```

See [Updates](/updates/) for channels (stable and beta) and automatic updates.

## Verify

```bash
flatpak remote-ls --updates
```

prints nothing when all apps are current.

```bash
flatpak list --app --columns=application,version
```

shows the installed versions.

## Troubleshooting

**The Store shows no updates but you expect some.** Close and reopen it to refresh. Then run `flatpak update` to see the truth from the command line.

**"Remote flathub not found" or network errors.** Check your connection and that Flathub is added. See [Flatpak basics](/desktop/apps/flatpak-basics/).

**An update asks for a password.** It is a system install. Enter your password, or reinstall the app with `--user` if you prefer.

**An app stays open on the old version.** Quit it and start it again. A running app does not change until it restarts.

**Disk space is low after many updates.** Run `flatpak uninstall --unused`.

## See also

- [Flatpak basics](/desktop/apps/flatpak-basics/)
- [Updates](/updates/)
