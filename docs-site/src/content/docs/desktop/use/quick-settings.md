---
title: Quick settings
description: What the quick settings panel at the top right contains and how to use its toggles, sliders and buttons.
sidebar:
  order: 60
---

**Applies to:** Desktop

Quick settings is the panel that opens from the group of icons at the right end of the top bar. It collects the controls you reach for most: volume, network, power mode, dark style and Do Not Disturb. It is the GNOME panel, in the Nubo glass look, with a few Nubo-relevant additions.

![The quick settings panel with volume, Wired, Power Mode, Dark Style, Do Not Disturb and GSConnect](../../../../assets/screens/quick.jpg)

## Before you begin

Nothing is needed. Which tiles you see depends on your hardware. A desktop computer with no Wi-Fi, no Bluetooth and no battery shows fewer tiles than a laptop.

## Open the panel

1. Click the group of icons at the right end of the top bar. You can also press <kbd>Super</kbd>+<kbd>S</kbd> (stock GNOME shortcut, unconfirmed on this build).
2. Click anywhere else, or press <kbd>Esc</kbd>, to close it.

## What you see

### Top row buttons

The top row has four round buttons:

- **Screenshot**: opens the screenshot tool. See [Screenshots and screen recording](/desktop/use/screenshots-and-screen-recording/).
- **Settings**: opens the Settings app.
- **Lock**: locks the screen.
- **Power**: opens a menu for suspend, restart and power off.

### Volume slider

Drag the slider to change the output volume. Click the speaker icon to mute. If you use more than one output, such as speakers and headphones, an arrow next to the slider lists them. See [Sound](/desktop/settings/sound/).

### Tiles

| Tile | What it does |
|---|---|
| Wired (or Wi-Fi) | Turns the network on or off. The arrow opens a list of networks. See [Network, Wi-Fi and Bluetooth](/desktop/settings/network-wifi-bluetooth/) |
| Power Mode | Cycles between power profiles. It shows the current one, such as Balanced. Which profiles exist depends on your hardware |
| Dark Style | Switches between dark and light appearance for the whole desktop. See [Light and dark appearance](/desktop/use/light-and-dark/) |
| Do Not Disturb | Stops notification banners. Notifications are still saved in the history. See [Notifications](/desktop/use/notifications/) |
| GSConnect | Lists your paired phones and their actions. See [Phone link](/desktop/use/phone-link/). The tile text is shortened to "GSCon..." in a narrow panel |

Laptops also show tiles for Bluetooth and, when the hardware supports them, Night Light and Airplane Mode. <!-- verify label: tile names for Bluetooth, Night Light, Airplane Mode are GNOME defaults, not confirmed in a Nubo screenshot -->

## Dark Style and Do Not Disturb in detail

The **Dark Style** tile is the quickest way to change appearance. It switches GNOME's color scheme. Nubo's session helper notices the change and updates the older app theme, the icon theme and the shell theme to match.

**Do Not Disturb** is shared with the Nubo notification history panel. Turning it on in either place turns it on in both, because both use GNOME's "show banners" setting.

## Verify

1. Open the panel and click **Dark Style**. The panel, the top bar and open apps change between dark and light within a moment.
2. Click **Do Not Disturb**. The tile lights up. Open the Nubo bell menu: its Do Not Disturb switch is on too.
3. Drag the volume slider. You should hear the alert sound the system plays at the new level if sound is on.

## Troubleshooting

**There is no Wi-Fi or Bluetooth tile.**
Cause: the hardware is missing, or a switch or key has turned it off. Fix: check any wireless key on a laptop, and see [Network, Wi-Fi and Bluetooth](/desktop/settings/network-wifi-bluetooth/).

**The GSConnect tile is missing.**
Cause: the GSConnect extension (`gsconnect@andyholmes.github.io`) is off. Fix: turn it on in the Extensions app or run `gnome-extensions enable gsconnect@andyholmes.github.io` in a terminal.

**Dark Style turns on but some apps stay light.**
Cause: some apps keep their own theme. Fix: check the app's own settings. Apps that use an unrelated GTK theme you chose yourself are not changed by Nubo.

## See also

- [The Nubo menu and top bar](/desktop/use/the-nubo-menu-and-top-bar/)
- [Notifications](/desktop/use/notifications/)
- [Power](/desktop/settings/power/)
