---
title: Multiple displays
description: Connect a second monitor or projector, choose between extending and mirroring, and learn how the dock, top bar and widgets behave.
sidebar:
  order: 150
---

**Applies to:** Desktop

Nubo OS handles several monitors and projectors the way GNOME does. This page shows how to set them up and explains what is specific to Nubo: where the dock, the widgets and the top bar appear.

## Before you begin

- A second display and a cable your computer supports (HDMI, DisplayPort or USB-C).
- The display turned on and set to the right input.

## Connect and arrange

1. Plug the display in. It should light up within a few seconds.
2. Open Settings and go to the displays page. <!-- verify label -->
3. Choose how the displays are used. The usual options are **Join** (extend the desktop across both), **Mirror** (show the same on both) or a single display. <!-- verify label -->
4. Drag the display rectangles to match how your monitors sit on the desk. The edge where they touch is the edge your pointer crosses.
5. Click a display and choose it as the primary display. The primary display is where the top bar's clock, the dock and the widgets appear. <!-- verify label -->
6. Apply the changes. GNOME asks you to confirm; if you do nothing it goes back after a few seconds.

You can also press <kbd>Super</kbd>+<kbd>P</kbd> to switch display modes quickly. <!-- verify label: GNOME default, unconfirmed on this build -->

## What happens where

| Part | Behavior with several displays |
|---|---|
| Top bar | On the primary display only, with the Nubo logo, the clock and quick settings. <!-- verify label --> |
| Dock | On the primary display only by default. The dock extension has a setting to show it on every display. <!-- verify label --> |
| [Desktop widgets](/desktop/use/widgets/) | Placed relative to the primary display. When you change the primary display, they move to it |
| Wallpaper | The same picture on every display |
| Windows | You can drag windows to another display. Workspaces span all displays by default in GNOME |

## Scaling

Each display has its own scale. A laptop's high resolution panel and an ordinary external monitor can use different settings, so text stays a comfortable size. See [Display and scaling](/desktop/settings/display-and-scaling/).

## Verify

1. Open the displays page in Settings. Both displays are listed with their names.
2. Move the pointer off the edge of one screen. It appears on the other.
3. Drag a window across. It follows.
4. Open the desktop on the primary display. The widgets are there.

## Troubleshooting

**The second display is black or not found.**
Cause: cable, adapter or input selection. Fix: replug, try another cable or port, check the display's input source. Some docks need a firmware or driver; check the hardware maker.

**The pointer crosses on the wrong side.**
Cause: the arrangement in Settings does not match your desk. Fix: drag the rectangles.

**The widgets are on the wrong screen.**
Cause: that screen is the primary display. Fix: choose the other display as primary, or reset positions. See [Desktop widgets](/desktop/use/widgets/).

**A window is lost after unplugging a display.**
Cause: the window stayed on a display that is gone. Fix: open the overview with <kbd>Super</kbd> and click the window; use <kbd>Super</kbd>+<kbd>Left</kbd> to place it on the screen. See [Windows and workspaces](/desktop/use/windows-and-workspaces/).

## See also

- [Display and scaling](/desktop/settings/display-and-scaling/)
- [Windows and workspaces](/desktop/use/windows-and-workspaces/)
- [Desktop widgets](/desktop/use/widgets/)
