---
title: Power
description: Choose a power mode, set when the screen turns off and the computer suspends, and check the battery.
sidebar:
  order: 40
---

**Applies to:** Desktop

Power settings on Nubo OS are GNOME's. They control how the computer saves energy, what happens when you close the lid and when the screen turns off. Nubo adds no battery or speed claims: how long a battery lasts depends on your hardware and how you use it.

## Before you begin

- A laptop shows battery and lid options; a desktop shows fewer.
- Some options, such as power modes, only appear if the hardware and the system's power profile service support them.

## Choose a power mode

1. Open [quick settings](/desktop/use/quick-settings/).
2. Click the **Power Mode** tile. It shows the current mode, for example Balanced, and cycles to the next when you click. <!-- verify label: other mode names are GNOME defaults -->

In Settings, on the power page, the same choice is listed with a short description of each mode. <!-- verify label -->

The usual modes are Balanced (the default), a mode that saves power, and, on some hardware, a performance mode.

## Screen off and suspend

1. Open [Settings](/desktop/settings/) and go to the power page. <!-- verify label -->
2. Under power saving, choose how long until the screen turns off when you are idle.
3. Choose when the computer suspends, on battery and when plugged in. <!-- verify label -->
4. On a laptop, choose what happens when you close the lid, if your version offers it. <!-- verify label -->

Screen lock after the screen goes off is a separate setting. See [Privacy and security](/desktop/settings/privacy-and-security/).

## Battery

On a laptop, the top bar shows a battery icon in the status area. Click the quick settings group to see the charge level. You can show the percentage in the top bar from the power page in Settings. <!-- verify label -->

## What Nubo changes

Nubo OS does not change power defaults and has no power service of its own; it uses Ubuntu's. The power profile tile you see in the screenshots appears on hardware where the profile service works.

## Turn off, restart and suspend

Use the power button in the top row of quick settings. It opens a menu for suspend, restart and power off. <!-- verify label -->

## Verify

1. Click the Power Mode tile. The label changes.
2. Set the screen to turn off after the shortest time and leave the computer alone. The screen turns off and wakes when you move the mouse.
3. On a laptop, unplug the charger. The battery icon changes.

## Troubleshooting

**There is no Power Mode tile.**
Cause: the hardware or driver does not offer power profiles, or the service is not running. Fix: nothing to do on unsupported hardware. On supported hardware, run `systemctl status power-profiles-daemon`. <!-- verify label: service name -->

**The laptop does not suspend when the lid closes.**
Cause: a setting, an external monitor is connected, or an app blocks suspend. Fix: check the lid option on the power page and unplug the external display to test.

**The computer does not wake from suspend.**
Cause: a hardware or firmware issue. Fix: install updates (`sudo apt update && sudo apt upgrade`) and check for firmware updates. <!-- verify label: firmware updates app -->

**The screen turns off during a presentation.**
Cause: idle timeout. Fix: lengthen the timeout or turn off screen blank while presenting.

## See also

- [Quick settings](/desktop/use/quick-settings/)
- [Privacy and security](/desktop/settings/privacy-and-security/)
- Ubuntu's documentation: https://ubuntu.com/desktop/docs
