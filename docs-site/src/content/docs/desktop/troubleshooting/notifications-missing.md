---
title: Notifications missing
description: Find out why notifications do not appear, especially from messaging apps whose window is closed.
sidebar:
  order: 60
---

**Applies to:** Desktop

Nubo OS has two parts for notifications. The **notification centre** is a panel with the history of notifications from every app. The **notification agent** (`nubo-notify-agent`) keeps messaging apps running in the background without a window, so they can receive messages and raise notifications even after you have closed them. A desktop app that has quit cannot receive anything, which is why the agent exists.

## Before you begin

- The app is installed. The agent only starts apps that are installed.
- A network connection, because messages arrive over the internet.
- A terminal.

## Steps

### 1. Check Do Not Disturb

Click the status icons at the top right. If the **Do Not Disturb** tile is on, banners are hidden. Turn it off. Notifications you missed are still in the notification centre.

![The quick settings menu with the Do Not Disturb tile](../../../../assets/screens/quick.jpg)

### 2. Open the notification centre

Click the date and time in the centre of the top bar. The left side of the panel lists notifications grouped by app. It says "No Notifications" when the list is empty. The **Clear** button at the bottom left empties it.

![The notification centre showing No Notifications](../../../../assets/screens/notif.jpg)

If the panel never lists anything, check the next steps.

### 3. Check the app's own notification setting

Open Settings and then Notifications. <!-- verify label --> Find the app in the list and make sure its notifications are on.

### 4. Check that the agent runs

```bash
systemctl --user status nubo-notify-agent
```

It should be `active (running)`. If it is not, start it:

```bash
systemctl --user restart nubo-notify-agent
```

### 5. Check which apps the agent manages

```bash
/usr/libexec/nubo/nubo-notify-agent list
```

The output has one line per app, with the app ID, its name, `on` or `off`, and `installed` or `not installed`. The agent supports these apps: Mail (Geary), Telegram, Slack, Discord and Signal. If your app shows `off`, turn it on:

```bash
/usr/libexec/nubo/nubo-notify-agent enable org.telegram.desktop
```

Use the ID from the first column. To turn one off, use `disable` with the same ID. The agent checks every 30 seconds, so it may take a short while to start the app.

### 6. Know the agent's rules

- It starts only installed apps.
- It leaves an app alone if it is already running.
- It restarts an app that crashed, waiting longer each time.
- If you chose Quit in the app, the app stays closed until your next login.

So if you quit an app on purpose, you will not get its notifications until you sign in again or start it yourself.

### 7. Check the extension

The notification centre is the GNOME Shell extension `nubo-notify-center@nubosuite.tech`.

```bash
gnome-extensions list --enabled | grep nubo
```

If it is missing, turn it on:

```bash
gnome-extensions enable nubo-notify-center@nubosuite.tech
```

## Verify

Close the window of a supported messaging app, send yourself a message from another device, and check that a banner appears. Then open the notification centre and see it in the list.

## Troubleshooting

- **No banner, but it is in the notification centre.** Do Not Disturb is on, or the app's banners are off in Settings.
- **The agent runs but an app does not start.** Check `list`. A line that says `not installed` means the app is not installed. Install it from Flathub. See [Apps not opening](/desktop/troubleshooting/apps-not-opening/).
- **The app you use is not on the list.** The list is fixed in `/usr/share/nubo/notify/background-apps.json`. Other apps behave as they do on any GNOME desktop: they notify only while they run.
- **Notifications arrive late.** Check your network, and whether the computer was asleep. Nubo has not measured delivery times.
- **Your settings do not stick.** The agent saves your choices in `~/.config/nubo/notify.json`.

## See also

- [Reset desktop settings](/desktop/troubleshooting/reset-desktop-settings/)
- [Collect logs for support](/desktop/troubleshooting/collect-logs-for-support/)
