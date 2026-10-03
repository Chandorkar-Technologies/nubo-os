---
title: Widgets not showing
description: Bring back the desktop widgets, or move one that is off screen.
sidebar:
  order: 70
---

**Applies to:** Desktop

The Nubo OS desktop has draggable cards on the wallpaper: a clock with weather, system usage (memory and processor), and a calendar. They come from the GNOME Shell extension `glass-widgets@peter-njoro.github.io`, which Nubo ships in its own build. This page helps when they are missing, hidden behind windows, or off screen.

![The desktop with the clock widget](../../../../assets/screens/desktop.jpg)

## Before you begin

- Widgets live on the desktop layer. Windows cover them. Minimize or move windows, or press <kbd>Super</kbd> to see the desktop in the overview, to check.
- You need a terminal.

## Steps

### 1. Check that the extension is on

```bash
gnome-extensions list --enabled | grep glass-widgets
```

If nothing is listed, turn it on:

```bash
gnome-extensions enable glass-widgets@peter-njoro.github.io
```

### 2. Check which widgets are switched on

Each widget has a switch in the extension's settings. The defaults are all on.

```bash
gsettings get org.gnome.shell.extensions.glass-widgets show-clock
gsettings get org.gnome.shell.extensions.glass-widgets show-stats
gsettings get org.gnome.shell.extensions.glass-widgets show-calendar
```

Turn one on with `true`:

```bash
gsettings set org.gnome.shell.extensions.glass-widgets show-clock true
gsettings set org.gnome.shell.extensions.glass-widgets show-stats true
gsettings set org.gnome.shell.extensions.glass-widgets show-calendar true
```

The clock also has `show-weather`. Changing a `show-` setting rebuilds the widgets at once.

### 3. Bring back a widget that is off screen

Nubo saves the position of each widget in `~/.config/nubo/widgets.json`. If you changed screen layout and a widget sits outside the screen, remove the saved positions:

```bash
rm ~/.config/nubo/widgets.json
```

Then turn the extension off and on again so the widgets return to their default places:

```bash
gnome-extensions disable glass-widgets@peter-njoro.github.io
gnome-extensions enable glass-widgets@peter-njoro.github.io
```

### 4. Weather does not appear

The clock shows weather when `show-weather` is on. By default Nubo sets automatic location (`weather-auto-location`) and the temperature unit setting `weather-temperature-unit`. Weather needs a network. Check the network, and check that location services are not switched off in Settings, then Privacy and Security. <!-- verify label -->

### 5. Check for errors

```bash
journalctl --user -b | grep -i "nubo widgets"
```

A line starting `nubo widgets: cannot save positions` means your home folder's `.config` is not writable.

## Verify

The widgets appear on the desktop. Drag one to a new place, sign out and in again, and check that it stays where you put it.

## Troubleshooting

- **The extension is listed as `ERROR` or `OUT OF DATE`.** Run `gnome-extensions info glass-widgets@peter-njoro.github.io`. Then sign out and in, or restart the session. Report it with your logs if it stays broken. See [Collect logs for support](/desktop/troubleshooting/collect-logs-for-support/).
- **The widgets work but have no blur.** The blur comes from another extension. See [Display flickers or resizes in a VM](/desktop/troubleshooting/display-flickers-or-resizes-in-a-vm/).
- **Widgets show on the wrong screen.** They follow the primary screen and reposition when the screen layout changes. Remove `widgets.json` as in step 3.
- **You do not want widgets.** Set the `show-` switches to `false`.

## See also

- [Reset desktop settings](/desktop/troubleshooting/reset-desktop-settings/)
- [A tour of your first day](/desktop/get-started/first-day-tour/)
