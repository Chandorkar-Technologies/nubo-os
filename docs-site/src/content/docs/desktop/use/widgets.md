---
title: Desktop widgets
description: Show, hide and move the clock with weather, system and calendar cards on your desktop, and reset their positions.
sidebar:
  order: 80
---

**Applies to:** Desktop

Nubo OS can show small cards on your desktop wallpaper: a clock with weather, a system card with memory and processor use, and a month calendar. They are drawn behind your windows, so they are visible when the desktop is clear and in the background of the overview. This page shows how to turn them on or off, move them, and reset them.

The widgets come from the Glass Widgets extension (`glass-widgets@peter-njoro.github.io`), an open source project by Peter Njoroge under the GPL-3.0. Nubo uses its own build of it: each card can be dragged, positions are remembered, a calendar card is added, and the square blur layer behind the cards was removed.

![The clock widget on the Nubo desktop](../../../../assets/screens/desktop.jpg)

## The three cards

| Card | What it shows |
|---|---|
| Clock | The time and date. When weather is on, the weather for your location is added |
| System | Memory (RAM) and processor (CPU) use |
| Calendar | The current month, with today highlighted. Weeks start on Monday |

The calendar card redraws once an hour. The clock and system cards are the upstream extension's own widgets.

## Before you begin

- The widgets extension must be on. It is on by default.
- The weather part of the clock needs an internet connection.
- Widgets live on the desktop background. If you cannot see them, move your windows aside or minimize them.

## Move a widget

1. Clear the desktop of windows, or open an empty workspace.
2. Press the primary mouse button on a card and drag it where you want it.
3. Let go. The new position is saved at once.

Positions are saved as fractions of the primary display's width and height, so they stay in the same place if you change the screen resolution. When you change the primary display, the cards are placed again on the new one.

The default positions (the center of each card as a fraction of the screen, across and down) are:

| Card | Across | Down |
|---|---|---|
| Clock | 0.50 | 0.20 |
| System | 0.84 | 0.32 |
| Calendar | 0.16 | 0.34 |

## Show or hide a card

Each card has a setting. Open a terminal and use `gsettings`:

```bash
gsettings set org.gnome.shell.extensions.glass-widgets show-calendar false
```

Use `true` to bring it back. Changes take effect at once.

### Settings keys

All keys are in the schema `org.gnome.shell.extensions.glass-widgets`.

| Key | Type | Nubo default | Meaning |
|---|---|---|---|
| `show-clock` | boolean | `true` | Show the clock card |
| `show-weather` | boolean | `true` | Show weather on the clock card |
| `show-stats` | boolean | `true` | Show the system card |
| `show-calendar` | boolean | `true` | Show the calendar card |
| `weather-auto-location` | boolean | `true` | Find your place automatically for the weather |
| `weather-temperature-unit` | integer | `0` | Which temperature unit is used (see the note below) |
| `blur-enabled` | boolean | `true` | Blur setting inherited from the upstream extension |

<!-- verify label: meaning of weather-temperature-unit values 0 and 1, and how weather-auto-location finds the place; not documented in the repo -->

:::note
The meaning of each `weather-temperature-unit` value and the way the automatic location works come from the upstream extension. They are not documented in the Nubo repository, so check them on your machine with `gsettings range org.gnome.shell.extensions.glass-widgets weather-temperature-unit`.
:::

## The file widgets.json

Positions are saved in `~/.config/nubo/widgets.json`. It is a small JSON file with one entry per card that you moved. Each entry is the card's center as two numbers between 0 and 1:

```json title="~/.config/nubo/widgets.json"
{
  "clock": [0.5, 0.2],
  "calendar": [0.16, 0.34]
}
```

A card with no entry uses its default position. You can edit the file by hand, but log out and in (or turn the extension off and on) to make the shell read it again.

### Reset the positions

1. Delete the file: `rm ~/.config/nubo/widgets.json`
2. Log out and in.

## Verify

1. Run `gsettings get org.gnome.shell.extensions.glass-widgets show-clock`. It prints `true`.
2. Drag the clock card to a new place. Open `~/.config/nubo/widgets.json`. It now has a `clock` entry with the new numbers.
3. Hide the calendar with the command above. The card disappears without logging out.

## Troubleshooting

**No cards at all.**
Cause: the extension is off, or all `show-` keys are `false`. Fix: run `gnome-extensions enable glass-widgets@peter-njoro.github.io`, and check the keys with `gsettings list-recursively org.gnome.shell.extensions.glass-widgets`.

**The weather is missing from the clock.**
Cause: no network, or location is off. Fix: check your connection. See [Privacy and security](/desktop/settings/privacy-and-security/) for location.

**A card is off screen or in a strange place after I changed displays.**
Cause: positions are relative to the primary display. Fix: reset the positions as above. See [Multiple displays](/desktop/use/multiple-displays/).

**The card cannot be dragged.**
Cause: a window is on top of it. Fix: show the desktop first.

## See also

- [Multiple displays](/desktop/use/multiple-displays/)
- [Wallpapers](/desktop/use/wallpapers/)
- [The Nubo menu and top bar](/desktop/use/the-nubo-menu-and-top-bar/)
