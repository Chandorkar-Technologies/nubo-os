---
title: Sound
description: Set the volume, choose speakers, headphones and microphones, and change the system alert sounds.
sidebar:
  order: 20
---

**Applies to:** Desktop

Sound on Nubo OS uses PipeWire with WirePlumber, as on Ubuntu 26.04 LTS. Nubo adds its own sound theme for system sounds. This page shows how to control volume and choose devices.

## Before you begin

- Speakers, headphones or a microphone connected, or Bluetooth devices paired. See [Network, Wi-Fi and Bluetooth](/desktop/settings/network-wifi-bluetooth/) for pairing.

## Change the volume quickly

1. Open [quick settings](/desktop/use/quick-settings/) at the top right.
2. Drag the volume slider. Click the speaker icon to mute.
3. If you have several outputs, the arrow next to the slider lists them. Choose one.

The keyboard volume keys on a laptop do the same.

## Choose devices in Settings

1. Open [Settings](/desktop/settings/) and go to the sound page. <!-- verify label -->
2. Under **Output**, choose the device (speakers, headphones, HDMI, Bluetooth).
3. Set the output volume. Set the balance if your device offers it.
4. Under **Input**, choose a microphone and check the level bar moves when you speak.
5. Under the volume levels, you can change the system alert volume and the alert sound. <!-- verify label -->

When you plug in headphones, the desktop usually switches to them. If it asks which device you plugged in, choose headphones or headset.

## The Nubo sound theme

The system sounds, such as the alert, message, completion, login and logout sounds, come from a theme called **Nubo**. Nubo sets it as the default in the desktop settings. The theme reuses the "ocean" sound set that Ubuntu's sound files include, with Nubo names for the events (bell, message, new mail, complete, login and logout). It comes from the `nubo-sounds` package.

To check which theme is active:

```bash
gsettings get org.gnome.desktop.sound theme-name
```

It prints `'Nubo'`. To turn off event sounds, switch off the sound option in Settings, or:

```bash
gsettings set org.gnome.desktop.sound event-sounds false
```

## Verify

1. Play a sound or video. You hear it from the chosen output.
2. Run `gsettings get org.gnome.desktop.sound theme-name`. It prints `'Nubo'`.
3. In Settings, speak into the microphone. The input level bar moves.

## Troubleshooting

**No sound at all.**
Cause: the wrong output, mute, or a muted slider in an app. Fix: check quick settings, then the output device in Settings. Check the app's own volume.

**Bluetooth headphones connect but are silent.**
Cause: the device is in a call profile or output is on another device. Fix: choose the device as output in Settings; in the device's settings pick a high quality profile if offered. <!-- verify label -->

**The microphone is not detected.**
Cause: disabled in the hardware, or a privacy switch. Fix: check any hardware mute key. Settings may list it under input; if not, try another port. See [Privacy and security](/desktop/settings/privacy-and-security/).

**Crackling or no device after an update.**
Cause: the audio service needs a restart. Fix: log out and in, or run `systemctl --user restart pipewire pipewire-pulse wireplumber`.

## See also

- [Quick settings](/desktop/use/quick-settings/)
- [Network, Wi-Fi and Bluetooth](/desktop/settings/network-wifi-bluetooth/)
- Ubuntu's documentation: https://ubuntu.com/desktop/docs
