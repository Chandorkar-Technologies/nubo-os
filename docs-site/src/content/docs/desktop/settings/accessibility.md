---
title: Accessibility
description: Turn on the screen reader, enlarge text, raise contrast and adjust keyboard and pointer behavior on Nubo OS.
sidebar:
  order: 80
---

**Applies to:** Desktop

Nubo OS includes GNOME's accessibility features. This page lists what GNOME offers and how it relates to the Nubo theme. Because the settings are GNOME's, the names of switches can differ slightly between versions; the page names the action and marks labels that are not confirmed. For the full guide see Ubuntu's accessibility documentation at https://ubuntu.com/desktop/docs.

:::note
No accessibility review of Nubo's own additions (the top bar logo, the notification history, desktop widgets and Nubo Search) is documented yet. If something blocks you, write to support@nubo.email and say what you use.
:::

## What is installed

The desktop depends on `at-spi2-core` and `libatk-adaptor` (the layer assistive tools use to read apps), and recommends `orca` (the screen reader), `speech-dispatcher` (speech) and `brltty` (braille displays).

## Before you begin

Open [Settings](/desktop/settings/) and find the accessibility page. <!-- verify label --> On many setups the top bar can also show an accessibility menu with quick toggles. <!-- verify label: icon is shown only after the option is on -->

## Seeing

### Screen reader

1. On the accessibility page, turn on the screen reader (Orca). <!-- verify label -->
2. Or press <kbd>Super</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd> to switch it on or off (GNOME default, unconfirmed on this build).

Orca speaks menus, text and buttons, and works with braille displays if `brltty` is set up. For a guided start with the screen reader, see Ubuntu's tutorial at https://ubuntu.com/desktop/docs.

### Large text

1. On the accessibility page, switch on large text. <!-- verify label -->

This scales the text without changing the screen scale. You can also raise the scale on the [display page](/desktop/settings/display-and-scaling/). Nubo's default font sizes are Inter 11 (interface) and Inter 12 (documents).

### Contrast and animations

GNOME offers a high contrast option and an option to reduce animations. <!-- verify label -->

Nubo's theme is dark with soft glass effects. If transparency is hard to read, turn on high contrast, or switch to the light style. See [Light and dark appearance](/desktop/use/light-and-dark/).

:::note
When you turn on high contrast, GNOME may change the theme to one that is not a Nubo theme. Nubo's session helper then leaves the theme alone until you pick a Nubo theme again.
:::

### Cursor size and zoom

Settings has a cursor size option. A screen magnifier (zoom) can be switched on and set to follow the pointer or keyboard focus. <!-- verify label --> Nubo's cursor is Bibata Modern Classic.

## Hearing

- Visual alerts flash the window or screen when an alert sound plays. <!-- verify label -->
- Sound settings and the volume slider are in [Sound](/desktop/settings/sound/).
- You can turn off event sounds or choose a different alert sound.

## Typing

| Option | What it does |
|---|---|
| On-screen keyboard | Shows a keyboard you can click or touch |
| Repeat keys | Sets how fast keys repeat, or turns repeat off |
| Sticky keys | Lets you press modifier keys one at a time |
| Slow keys | Ignores keys held for a very short time |
| Bounce keys | Ignores quick double presses |
| Cursor blinking | Turns blinking off in text fields |

These are GNOME's typing assist options. <!-- verify label --> For layout shortcuts, see [Keyboard and input](/desktop/settings/keyboard-and-input/).

## Pointing and clicking

- Mouse keys let the number pad move the pointer.
- Click assist can click for you when the pointer rests, or turn a hold into a right click.
- Double-click delay and pointer speed are in the mouse page of Settings.

## Verify

1. Turn on a feature, for example large text. The change is visible at once.
2. For the screen reader, press <kbd>Super</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd> and listen for speech. Press it again to stop.
3. Run `gsettings get org.gnome.desktop.a11y.applications screen-reader-enabled` to see if the screen reader is on. <!-- verify label -->

## Troubleshooting

**The screen reader says nothing.**
Cause: sound is off or `orca` is not installed. Fix: check [Sound](/desktop/settings/sound/). Check with `which orca`; install with `sudo apt install orca`.

**Some apps are not read.**
Cause: not every app exposes full accessibility information. Some Flatpak apps and web apps differ. Fix: try the app's keyboard navigation; report the issue to the app's authors and to support@nubo.email.

**The shell looks different after high contrast.**
Cause: GNOME changed the theme. Fix: turn high contrast off and set `Nubo-Grey-Dark` again as shown in [Light and dark appearance](/desktop/use/light-and-dark/).

**Text is too big in some apps.**
Cause: large text and scale add up. Fix: use one or the other.

## See also

- [Keyboard and input](/desktop/settings/keyboard-and-input/)
- [Display and scaling](/desktop/settings/display-and-scaling/)
- [Light and dark appearance](/desktop/use/light-and-dark/)
- Ubuntu's accessibility documentation: https://ubuntu.com/desktop/docs
