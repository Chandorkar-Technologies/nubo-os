---
title: Startup and background apps
description: See which apps start with your session, which keep running in the background, and how to start your own app at login.
sidebar:
  order: 130
---

**Applies to:** Desktop

Some programs start by themselves when you log in. Some of them have no window. This page lists the ones Nubo OS starts, shows how to turn them off and how to start an app of your own at login.

## What Nubo OS starts at login

These services run as part of your session. They have no window.

| Service | What it does | Learn more |
|---|---|---|
| `nubo-session-helper` | Keeps the theme in step with light and dark, adds Nubo's extensions to your list, sets the default avatar and the Nubo Search shortcut | [Light and dark appearance](/desktop/use/light-and-dark/) |
| `nubo-notify-agent` | Keeps messaging apps running without a window so notifications arrive | [Notifications](/desktop/use/notifications/) |
| `nubo-app-stubs` | Writes the grey launchers for popular apps, once at login | [Dock and app grid](/desktop/use/dock-and-app-grid/) |
| Nubo Search service | Keeps the launcher ready (`nubo-search server`) | [Nubo Search](/desktop/use/nubo-search/) |

The first three are systemd user services tied to the GNOME session. They are not started when you boot from the installation media. The search service starts from an autostart entry for GNOME.

## Before you begin

- Open a terminal for the commands below.
- To make background changes survive, make them as your user, not with `sudo`.

## See background apps

The messaging apps the agent keeps alive are in a list. To see them and their state:

```bash
/usr/libexec/nubo/nubo-notify-agent list
```

Each line shows the app id, name, `on` or `off`, and `installed` or `not installed`.

## Stop an app from running in the background

1. Disable it in the agent:

```bash
/usr/libexec/nubo/nubo-notify-agent disable org.telegram.desktop
```

2. Log out and in so the agent stops starting it. An app that is already running keeps running until you quit it.

To bring it back, use `enable` with the same id. Your choices are saved in `~/.config/nubo/notify.json`.

You can also look at what apps are allowed to run in the background from the apps page of [Settings](/desktop/settings/). <!-- verify label -->

## Start an app at login

GNOME starts every `.desktop` file found in `~/.config/autostart/` when you log in.

1. Create the folder if it is missing: `mkdir -p ~/.config/autostart`
2. Copy the app's launcher into it. For a system app:

```bash
cp /usr/share/applications/org.gnome.Calendar.desktop ~/.config/autostart/
```

3. Log out and in. The app starts with the session.

To stop it, delete the copy from `~/.config/autostart/`.

For apps installed from Flathub, the launcher is in `/var/lib/flatpak/exports/share/applications/` (system install) or `~/.local/share/flatpak/exports/share/applications/` (per user). <!-- verify label: paths are standard Flatpak locations -->

:::note
Ubuntu's Startup Applications tool is not part of the Nubo OS desktop packages. Use the autostart folder as shown here. <!-- verify label: gnome-session-properties availability -->
:::

## Turn Nubo extensions off

Nubo's own shell extensions (the logo menu, the notification center, the widgets and others) can be turned off in the Extensions app if installed, or with `gnome-extensions disable UUID`. Nubo's login helper adds each extension to your list once, so it does not turn one back on after you switch it off.

## Verify

1. Run `systemctl --user status nubo-session-helper nubo-notify-agent` to see both running.
2. Run `/usr/libexec/nubo/nubo-notify-agent list`. The apps you disabled show `off`.
3. After adding an autostart entry, log out and in. The app opens.

## Troubleshooting

**An app I disabled still runs.**
Cause: it was already running, or you start it yourself. Fix: quit it, and check `~/.config/autostart/`.

**My autostart entry does nothing.**
Cause: the launcher's `Exec` line fails or the file name does not end in `.desktop`. Fix: run the command from a terminal to see its error.

**The app starts but its window appears every time.**
Cause: the app has no option to start hidden. Fix: look for a start minimized option in the app's settings.

**A systemd service is "failed".**
Cause: a crash during login. Fix: `journalctl --user -u nubo-notify-agent -b` and write to support@nubo.email with the output. The agent restarts itself on failure after 10 seconds.

## See also

- [Notifications](/desktop/use/notifications/)
- [Default apps](/desktop/settings/default-apps/)
- [Light and dark appearance](/desktop/use/light-and-dark/)
