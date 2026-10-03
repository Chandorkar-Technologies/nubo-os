---
title: A tour of your first day
description: A hands-on walk through the Nubo OS desktop, from the top bar to the app grid, notifications, quick settings and search.
sidebar:
  order: 60
---

**Applies to:** Desktop

In this tutorial you walk through the Nubo OS desktop piece by piece. By the end you will know where everything is and have tried the things you will use every day. It takes about fifteen minutes.

## Before you begin

- Nubo OS installed and running. See [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/).
- You are signed in. See [Your first login](/desktop/get-started/first-login/).
- The first boot has finished, so your apps are installed.

The screenshots come from a development machine, so the dock icons in them differ a little from the ones you see. The layout is the same.

## 1. The desktop

![The Nubo desktop with the clock widget and the floating dock](../../../../assets/screens/desktop.jpg)

You see a clean desktop with four parts:

- **The wallpaper.** The default is a photograph, with a lighter one for the light theme and a darker one for the dark theme. Eight photographs ship with Nubo OS.
- **The top bar.** It is 40 pixels high. At the left is the Nubo logo with the text "Nubo OS 1". The date and time are in the centre. Status icons and the power button are at the right.
- **The clock widget.** A card with the time and date. It can also show weather, system usage and a calendar. Drag it anywhere. Nubo remembers where you put it.
- **The dock.** A floating bar, centred at the bottom, with your favorite apps. The default favorites are Firefox, Mail (Geary), Files, Calendar, Reminders, Software and Settings.

Desktop icons for Home, Trash and mounted drives are turned off by default, so the wallpaper stays clean.

**Try it:** drag the clock widget to a corner.

## 2. The overview and the app grid

Click the Nubo logo at the top left. There is no menu; it opens the Activities overview straight away.

![The app overview with the search box, workspaces and app folders](../../../../assets/screens/grid1.jpg)

The overview shows:

- A search box at the top, with the hint "Type to search".
- Your workspaces as thumbnails under it.
- The app grid below, in pages. Dots near the bottom show which page you are on. Use the arrows at the sides, or scroll, to change pages.
- Folders. Utilities holds system tools, and Accessories holds small everyday tools. The folders keep the front pages for apps you use.

**Try it:** click the Utilities folder to open it, then press <kbd>Esc</kbd>.

## 3. Grey icons

Go to the next page of the grid.

![The app grid with grey placeholder icons for popular apps](../../../../assets/screens/grid2.jpg)

Some icons are grey, such as Blender, Brave, Discord, Dropbox, GIMP, Inkscape, Krita, OBS Studio and Obsidian. These are placeholders for popular apps that are not installed yet. Click one and Nubo downloads the app from Flathub, shows a small progress window, and opens the app when it is ready. After that, the grey icon is replaced by the real one.

Apps that are not Flathub apps, such as WhatsApp and YouTube, open as web apps in their own window. <!-- verify label -->

**Try it:** click a grey icon that you would use, and wait for it to open. This needs a network.

## 4. Calendar and notifications

Click the date and time in the centre of the top bar.

![The notification centre with the calendar and the weather](../../../../assets/screens/notif.jpg)

A panel opens. At the left is the notification centre: the history of notifications from all your apps, grouped by app, with a **Clear** button at the bottom left. At the right are the calendar, today's events, a link to add world clocks and the weather forecast for your place.

Nubo also runs a small background helper that keeps messaging apps such as Geary, Telegram, Slack, Discord and Signal ready, so you get their notifications even when you have closed their windows.

**Try it:** open the panel, click an arrow beside the month name to move through the calendar, and press <kbd>Esc</kbd> to close it.

## 5. Quick settings

Click the group of icons at the top right.

![The quick settings menu with network, power mode, dark style and Do Not Disturb](../../../../assets/screens/quick.jpg)

The menu has:

- Buttons at the top for a screenshot, Settings, lock and power.
- A volume slider.
- Tiles for your network, the power mode, **Dark Style**, **Do Not Disturb** and, if you use it, the GSConnect phone link.

Dark Style switches between the dark and the light theme. Nubo follows this switch for apps old and new. Do Not Disturb hides notification banners; they still appear in the notification centre.

**Try it:** turn Dark Style off and on again.

## 6. Nubo Search

Press <kbd>Super</kbd>+<kbd>Space</kbd>. A launcher opens in the middle of the screen. Type the name of an app to open it, a sum to calculate it, or a file name. Nubo Search can also show the clipboard history. Press <kbd>Esc</kbd> to close it.

The <kbd>Super</kbd>+<kbd>Space</kbd> shortcut belongs to Nubo Search. To switch the keyboard layout, press <kbd>Alt</kbd>+<kbd>Shift</kbd>.

**Try it:** press <kbd>Super</kbd>+<kbd>Space</kbd>, type the first letters of Settings, and press <kbd>Enter</kbd>.

## 7. Settings

Open Settings from the dock or from Nubo Search.

![Settings, About page, showing Nubo OS 1](../../../../assets/screens/about.jpg)

The sidebar lists the usual GNOME Settings pages, such as Notifications, Search, Online Accounts, Sharing, Wellbeing, Mouse and Touchpad, Keyboard, Color Management, Printers, Accessibility, Privacy and Security and System. The About page under System shows the Nubo mark and "Nubo OS 1".

**Try it:** open System, then About, and note your version.

## What you built

You have a desktop that is yours: a placed widget, an overview you can navigate, one more app from Flathub, and a few shortcuts in your hands.

## Verify

You can do each of these without help: open the overview, open Nubo Search with <kbd>Super</kbd>+<kbd>Space</kbd>, open the notification panel, and switch Dark Style.

## Troubleshooting

- **No widget is visible.** See [Widgets not showing](/desktop/troubleshooting/widgets-not-showing/).
- **A grey icon does nothing.** Check the network. See [Apps not opening](/desktop/troubleshooting/apps-not-opening/).
- **No notifications from a messaging app.** See [Notifications missing](/desktop/troubleshooting/notifications-missing/).
- **<kbd>Super</kbd>+<kbd>Space</kbd> does nothing.** See [Reset desktop settings](/desktop/troubleshooting/reset-desktop-settings/).

## Next steps

- [Use the desktop](/desktop/use/) for each feature in depth.
- [Apps](/desktop/apps/) for what comes installed and how to add more.
- [Settings](/desktop/settings/) for appearance and keyboard.
