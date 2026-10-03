---
title: Messaging and background apps
description: How Nubo OS keeps mail and chat apps running without a window so notifications arrive, and how to turn an app on or off or add one.
sidebar:
  order: 80
---

**Applies to:** Desktop

A desktop app that has quit cannot receive a message. Phones solve this by running messaging apps in the background. Nubo OS does the same with a small program, the notification agent (`nubo-notify-agent`). It starts chosen apps without a window, so they can raise notifications even after you close their window.

The notification history panel is a separate part. It is a shell extension called `nubo-notify-center`, and it lists past notifications. This page is about the agent.

## Which apps

The system list is the file `/usr/share/nubo/notify/background-apps.json`. It holds five apps today:

| Id | Name | Provided as | How it is started |
|---|---|---|---|
| `geary` | Mail | Package | `geary --gapplication-service` |
| `org.telegram.desktop` | Telegram | Flatpak | `-startintray` |
| `com.slack.Slack` | Slack | Flatpak | `--startup` |
| `com.discordapp.Discord` | Discord | Flatpak | `--start-minimized` |
| `org.signal.Signal` | Signal | Flatpak | `--start-in-tray` |

## How the agent behaves

- It starts with your session and waits about ten seconds for the session to settle.
- It checks the list every 30 seconds.
- It starts only apps that are installed. An app that is already running is left alone.
- If an app crashes (exits with an error), it is started again after a delay that doubles each time, up to ten minutes.
- If an app exits normally, because you chose Quit, the agent leaves it closed until your next login.
- You can switch any app off.

## Before you begin

- A terminal.
- The app installed. For Flatpak apps such as Telegram, see [Popular apps: click to download](/desktop/apps/popular-apps-click-to-download/).

## See the state

```bash
nubo-notify-agent list
```

Each line shows the id, the name, `on` or `off`, and `installed` or `not installed`.

## Turn an app off or on

```bash
nubo-notify-agent disable com.slack.Slack
nubo-notify-agent enable com.slack.Slack
```

The choice is saved in `~/.config/nubo/notify.json` under the key `disabled`. It applies to the next check, and an app that is already running keeps running until you quit it.

## Add an app

The agent has no setting to add an app for one user. It reads only the system list. To add an app, add an entry to `/usr/share/nubo/notify/background-apps.json` as an administrator.

1. Find out how to start the app without a window. Most chat apps have an option such as "start minimized" or "start in tray". Look in the app's own help or run it with `--help`.
2. Open the file:

```bash
sudo nano /usr/share/nubo/notify/background-apps.json
```

3. Add an entry. For a Flatpak app, use `id`, `name`, `flatpak` and `args`:

```json title="/usr/share/nubo/notify/background-apps.json"
{"id": "org.example.Chat", "name": "Example", "flatpak": "org.example.Chat", "args": ["--start-minimized"]}
```

   For a package from the archive, use `command` (the program and its arguments) and `match` (the process name used to see if it is already running):

```json
{"id": "example", "name": "Example", "command": ["example", "--background"], "match": "example"}
```

   Separate entries with commas, as in the existing list.
4. Restart the agent:

```bash
systemctl --user restart nubo-notify-agent
```

:::caution
The file is part of the `nubo-notify` package. A package update can replace it and remove your entry. Keep a copy of your change.
:::

## Verify

- `nubo-notify-agent list` shows the new app as `on` and `installed`.
- `systemctl --user status nubo-notify-agent` says it is active.
- Close the window of a listed chat app and send yourself a message from your phone. A notification should appear.

## Troubleshooting

**An app is not started.** The list shows `not installed`, or the id is wrong. For Flatpak entries the `flatpak` value must be the exact Flathub id.

**The app opens a window every time.** Its `args` do not hide the window. Check the app's start options.

**You quit an app and it does not come back.** That is intended. A normal quit stays closed until you log in again.

**The JSON file breaks the agent.** If the file has a typo, the agent cannot read it. Restore the file with `sudo apt install --reinstall nubo-notify`, then redo your change.

**You want no background apps.** Disable each id, or stop the service: `systemctl --user disable --now nubo-notify-agent`.

## See also

- [Mail with Geary](/desktop/account/mail-with-geary/)
- [Desktop](/desktop/)
