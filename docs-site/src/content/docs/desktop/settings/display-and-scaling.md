---
title: Display and scaling
description: Change resolution, scale, refresh rate and orientation, and turn on Night Light.
sidebar:
  order: 10
---

**Applies to:** Desktop

Display settings on Nubo OS are GNOME's. This page shows how to make text and windows a comfortable size, and how to set up the screen. For several monitors see [Multiple displays](/desktop/use/multiple-displays/).

## Before you begin

- The display must be connected and detected. Laptop panels are detected automatically.
- If you use a virtual machine, the display settings may be limited by the host; the desktop includes `spice-vdagent` for guest integration.

## Change the resolution and scale

1. Open [Settings](/desktop/settings/) and go to the displays page. <!-- verify label -->
2. Pick your display if you have more than one.
3. Choose a **Resolution**. The native resolution of the screen is usually the best choice and is often marked.
4. Choose a **Scale**. A larger scale makes text and controls bigger without changing the picture sharpness. Typical choices are 100%, 200%, and in between values where your session offers them. <!-- verify label: availability of fractional scales depends on the session and GNOME settings; Nubo does not change this -->
5. If your screen supports several refresh rates, choose one under **Refresh Rate**. <!-- verify label -->
6. Click **Apply**. If the picture looks wrong, do nothing for a few seconds, and GNOME goes back to the previous setting. <!-- verify label -->

### Orientation

On a screen that can rotate, pick an orientation: landscape, portrait left or right, or landscape flipped. <!-- verify label -->

## Night Light

Night Light makes the screen warmer in the evening.

1. On the displays page, open **Night Light**. <!-- verify label -->
2. Turn it on and choose a schedule, either from sunset to sunrise or at times you choose.
3. Adjust the color temperature with the slider.

The sunset schedule needs your location. If location is off, choose manual times. See [Privacy and security](/desktop/settings/privacy-and-security/).

## Text size only

If you want bigger text but the same screen scale, use the accessibility setting for large text. See [Accessibility](/desktop/settings/accessibility/). The Nubo interface font is Inter at size 11, the document font is Inter at 12 and the monospace font is JetBrains Mono at 11.

## What Nubo changes

Nubo does not set any display option by default. The frosted look of the bars and dock is drawn by the shell and depends on your graphics hardware. If the blur looks slow on old hardware, you can turn the Blur my Shell extension off. See [The Nubo menu and top bar](/desktop/use/the-nubo-menu-and-top-bar/).

## Verify

1. After you apply, the new size is visible at once.
2. Open the displays page again. The resolution and scale you chose are selected.
3. If you turned on Night Light, the colors shift when the schedule starts. To test, set the schedule to manual and choose a time one minute ahead.

## Troubleshooting

**The screen is blurry.**
Cause: a resolution that is not the native one. Fix: choose the native resolution and use scale for bigger text.

**There is no 125% or 150% scale.**
Cause: fractional scaling is not offered for this display or session. Fix: use 200% with a smaller resolution, or use the large text option for text only.

**The screen is black after applying.**
Cause: the display does not support the mode. Fix: wait; the old mode returns after a few seconds. If not, press <kbd>Super</kbd>+<kbd>P</kbd> to change display mode, or reboot.

**Blur effects are slow.**
Cause: weak graphics hardware. Fix: turn off the Blur my Shell extension.

## See also

- [Multiple displays](/desktop/use/multiple-displays/)
- [Accessibility](/desktop/settings/accessibility/)
- Ubuntu's documentation: https://ubuntu.com/desktop/docs
