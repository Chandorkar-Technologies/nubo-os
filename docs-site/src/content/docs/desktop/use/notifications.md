---
title: Notifications
description: How notifications work on Nubo OS, including the history panel, Do Not Disturb and the background agent that keeps messaging apps alive.
sidebar:
  order: 70
---

**Applies to:** Desktop

Nubo OS adds two things to GNOME's notifications. The first is a history panel, so you can read what you missed. The second is a background agent that keeps messaging apps running without a window, so messages still reach you after you close them. This page explains both and shows how to control them.

![The calendar panel with the Notifications area on the left and a Clear button](../../../../assets/screens/notif.jpg)

## Where notifications appear

1. **Banners** pop up at the top of the screen when something arrives.
2. **GNOME's panel** opens when you click the date in the top bar. Unread notifications wait there with a **Clear** button.
3. **The Nubo history panel** is a button at the right of the top bar. It shows a bell and, when there are unread notifications, a number. The number tops out at "99+".

## The history panel

The Nubo notification center is a shell extension (`nubo-notify-center@nubosuite.tech`). It records every notification any app sends: system apps, Flatpak apps, web apps run from the browser, and phone notifications from GSConnect.

- Notifications are grouped by app, with the app name in capitals.
- Each entry has a title, the text and how long ago it arrived ("now", then minutes, hours and days).
- Up to 20 entries per app are shown.
- Opening the panel marks everything as read.

### Do Not Disturb and Clear all

The menu at the top of the panel has two items:

- **Do Not Disturb**: a switch. It hides banners. New notifications are still recorded. The switch is the same one as in [Quick settings](/desktop/use/quick-settings/).
- **Clear all**: empties the history.

### Where the history is kept

History stays on your computer in `~/.local/share/nubo/notification-history.json`. At most 200 entries are kept, and entries older than 7 days are dropped when the panel loads. Nothing is sent anywhere. To remove it, use **Clear all**, or delete the file.

## The background agent

Phones receive messages while the app is closed. On a computer, a closed app cannot. To bridge this, Nubo OS runs `nubo-notify-agent` as a service in your session. It starts a few messaging apps without opening a window.

### Which apps

The agent reads the list in `/usr/share/nubo/notify/background-apps.json`. In this release it is:

| App | How it is started |
|---|---|
| Mail (Geary) | From the Ubuntu package, as a background service |
| Telegram | Flatpak, started in the tray |
| Slack | Flatpak, started in the background |
| Discord | Flatpak, started minimized |
| Signal | Flatpak, started in the tray |

Rules the agent follows:

- It only starts apps that are installed.
- It leaves apps alone that are already running.
- If an app crashes, the agent restarts it after a delay that grows each time, to a maximum of ten minutes.
- If you quit an app on purpose, the agent does not start it again until your next login.
- It checks every 30 seconds, and waits ten seconds after login before the first check.

### How apps get added

Apps get on the list in two ways today. Nubo adds them to the list file in a package update. You cannot add your own app through your own configuration, because the agent only reads your personal file to see which apps you turned off. An app you install later, for example Telegram from the grey icon in the app grid, is picked up on the next check if it is on the list.

You can edit the system list file yourself with administrator rights, but a package update may replace it.

### Turn an app off or on

Open a terminal and use the agent's commands:

```bash
/usr/libexec/nubo/nubo-notify-agent list
/usr/libexec/nubo/nubo-notify-agent disable org.telegram.desktop
/usr/libexec/nubo/nubo-notify-agent enable org.telegram.desktop
```

`list` shows each app, whether it is on or off for you, and whether it is installed. Your choices are saved in `~/.config/nubo/notify.json`. The agent is installed in `/usr/libexec/nubo/`, which is not on the normal command path, so use the full path.

## Verify

1. Send yourself a notification from a terminal: `notify-send "Test" "Hello from Nubo"`. A banner appears.
2. Open the bell menu at the top right. Under the app name you should see "Test".
3. Run `/usr/libexec/nubo/nubo-notify-agent list`. The output has one line per app with `on` or `off` and `installed` or `not installed`.

## Troubleshooting

**I do not get messages when the app is closed.**
Cause: the app is not installed, you turned it off, or you quit it on purpose in this session. Fix: run `/usr/libexec/nubo/nubo-notify-agent list`. Re-enable it, then log out and in.

**An app I want is not on the list.**
Cause: the list is fixed by the package. Fix: leave the app open in its tray, or ask for it at support@nubo.email.

**The bell shows no history after a restart.**
Cause: history is kept for 7 days and 200 entries; or the file was deleted. Fix: nothing to repair; new notifications will be recorded.

**Banners do not appear.**
Cause: Do Not Disturb is on. Fix: turn it off in quick settings or the bell menu.

## See also

- [Quick settings](/desktop/use/quick-settings/)
- [Phone link](/desktop/use/phone-link/)
- [Startup and background apps](/desktop/settings/startup-and-background-apps/)
- [Privacy and security](/desktop/settings/privacy-and-security/)
