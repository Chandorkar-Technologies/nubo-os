---
title: Flatpak basics
description: What Flatpak is, how Nubo OS uses it with Flathub, and the commands you need day to day.
sidebar:
  order: 40
---

**Applies to:** Desktop

Flatpak is a way to package desktop apps so that one build runs on many Linux systems. Each app brings its own libraries and runs in a sandbox. Nubo OS includes Flatpak (the `flatpak` package) and uses Flathub as the source of most user apps.

## Why Nubo OS uses it

- Apps such as Spotify, Slack or Collabora Office are not in Ubuntu's archive, or are not kept up to date there. Flathub carries them.
- Apps update separately from the system.
- The Nubo image does not need to include proprietary apps. You download them yourself.

## Remotes: where apps come from

A remote is a source of apps. Nubo OS uses **Flathub**.

- At first boot, Nubo adds Flathub for the whole system (`--system`), if there is a network.
- `nubo-get` (the grey placeholder icons) adds Flathub for your user (`--user`) if it is missing, and installs into your user area.

So your computer can hold apps in two places:

| Install type | Flag | Who can use it | Needs administrator rights |
|---|---|---|---|
| System | `--system` (the default for most commands) | Everyone on the computer | Yes |
| User | `--user` | Only you | No |

Apps installed at first boot (Firefox, Collabora Office, VLC and others) are system installs. Apps from a grey icon are user installs.

## Before you begin

- A terminal. Open it from the app grid (the app is called **Terminal**).
- Flathub added. Check:

```bash
flatpak remotes
```

You should see `flathub`.

## Common commands

```bash
flatpak search vlc                          # find an app
flatpak install flathub org.videolan.VLC    # install it
flatpak run org.videolan.VLC                # start it from a terminal
flatpak list --app                          # list installed apps
flatpak info org.videolan.VLC               # details of one app
flatpak update                              # update everything
flatpak uninstall org.videolan.VLC          # remove an app
flatpak uninstall --unused                  # remove runtimes no app needs
```

Add `--user` or `--system` if the command asks which installation to use.

## The id of an app

Every app has an id such as `org.videolan.VLC`. It is also the name of its data folder, `~/.var/app/org.videolan.VLC`. The ids of the popular apps are in [the popular apps table](/desktop/apps/popular-apps-click-to-download/).

## Permissions

A sandboxed app can only reach what it has been given: your files, the network, the camera, and so on. Flatpak shows these in the Nubo Store on the app's page, and you can change them in Settings. <!-- verify label -->

From the terminal:

```bash
flatpak info --show-permissions org.videolan.VLC
flatpak override --user --filesystem=~/Videos org.videolan.VLC
flatpak override --user --reset org.videolan.VLC
```

Give only what the app needs.

## Runtimes

An app needs a runtime, a shared set of libraries. Runtimes download once and are shared. This is why the first Flatpak install is bigger than later ones.

## Verify

```bash
flatpak list --app
```

lists what you installed and its origin.

## Troubleshooting

**"Remote flathub not found".** Add it:

```bash
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

**Permission denied when installing.** A system install needs administrator rights. Add `--user`, or use `sudo`.

**An app cannot open a file.** The sandbox may not allow that folder. Open the file through the app's own file chooser, which uses a portal, or grant the folder with `flatpak override`.

**Disk is filling up.** Run `flatpak uninstall --unused`.

## See also

- Flatpak documentation: https://docs.flatpak.org
- [Install and remove apps](/desktop/apps/install-and-remove-apps/)
- [Update apps](/desktop/apps/update-apps/)
