---
title: Phone link
description: Pair an Android phone with GSConnect to share files, clipboard and notifications, and mirror its screen with scrcpy.
sidebar:
  order: 130
---

**Applies to:** Desktop

Nubo OS includes two tools for working with a phone. **GSConnect** is a GNOME Shell extension that pairs your phone and computer over your local network. **scrcpy** shows and controls an Android phone's screen on your computer. This page shows how to pair an Android phone and what to expect from an iPhone.

GSConnect speaks the protocol of KDE Connect, so on the phone you install the KDE Connect app. GSConnect is an open source project by Andy Holmes. scrcpy is an open source project by Genymobile.

## What works

| Feature | Android | iPhone |
|---|---|---|
| Pairing with the computer | Yes, with the KDE Connect app | Limited |
| Phone notifications on the computer | Yes | Limited |
| Send files in both directions | Yes | Limited |
| Share clipboard | Yes | Limited |
| Mirror and control the screen | Yes, with scrcpy over USB | No |

The Nubo notification history includes notifications forwarded by GSConnect. See [Notifications](/desktop/use/notifications/).

:::caution[iPhone]
Apple limits what other software can do with an iPhone. Nubo has not tested an iPhone with GSConnect, and does not promise any feature. If you try the iOS version of KDE Connect, expect fewer features than on Android. <!-- verify label: iOS support level not tested -->
:::

## Pair an Android phone

### Before you begin

- Your phone and computer must be on the same network (the same Wi-Fi or the same router).
- The KDE Connect app installed on the phone, from your phone's app store.
- The GSConnect extension must be on in Nubo OS. It is on by default. A tile for it appears in [quick settings](/desktop/use/quick-settings/).
- If a firewall is active on your computer, it must allow KDE Connect traffic. The Nubo desktop packages do not set up a firewall. <!-- verify label: ports used by GSConnect are 1714 to 1764, TCP and UDP; confirm against GSConnect docs -->

### Steps

1. Open quick settings and click the GSConnect tile, or open its menu from the top bar. <!-- verify label -->
2. Open the KDE Connect app on the phone. The phone lists your computer as a device found on the network.
3. Tap your computer and request pairing.
4. On the computer, accept the pairing request that appears as a notification.
5. Open the GSConnect settings for the phone to choose what to allow, such as notifications, clipboard or files. <!-- verify label -->

![Quick settings with the GSConnect tile](../../../../assets/screens/quick.jpg)

### What you can do after pairing

- Send a file from the phone's share menu to the computer, or from the computer to the phone.
- See phone notifications on the desktop, and reply where the app allows.
- Copy text on one device and paste it on the other.
- Ring the phone to find it.
- Use the phone as a remote control for volume and media.

The exact list depends on the plugins you switch on in GSConnect's settings. <!-- verify label -->

## Mirror an Android phone with scrcpy

scrcpy shows the phone's screen in a window and lets you click and type on it. Nubo installs the `scrcpy` package with the desktop.

### Before you begin

- A USB cable that carries data, not only power.
- On the phone, developer options turned on and **USB debugging** switched on. The steps differ by phone make; search your phone maker's help for "USB debugging".

### Steps

1. Connect the phone to the computer with the cable.
2. If the phone asks to allow USB debugging for this computer, accept it.
3. Open a terminal and run:

```bash
scrcpy
```

4. A window opens with the phone's screen. Click and type in it. Close the window to stop.

scrcpy has more options, for example for wireless connection, recording and window size. See `scrcpy --help` or the project's documentation.

## Verify

- After pairing, the GSConnect tile or menu lists your phone as connected.
- Send a file from the phone. A notification appears and the file is saved on the computer, typically in the Downloads folder. <!-- verify label -->
- With the cable connected, `scrcpy` shows the phone screen.

## Troubleshooting

**The phone does not see the computer.**
Cause: different networks, a guest Wi-Fi that isolates devices, or a firewall blocking the ports. Fix: put both on the same ordinary network and check the firewall.

**Pairing request never arrives.**
Cause: the extension is off or notifications are hidden. Fix: turn off Do Not Disturb, and check the extension with `gnome-extensions enable gsconnect@andyholmes.github.io`.

**scrcpy: "no devices found" or "unauthorized".**
Cause: USB debugging is off, or you did not accept the prompt on the phone. Fix: switch debugging on, replug the cable, accept the prompt. Run `adb devices` if you have it to see the status.

**The cable charges but the computer does not see the phone.**
Cause: a charge-only cable, or the phone is in "charging only" mode. Fix: use another cable, and on the phone choose file transfer in the USB notification.

## See also

- [Notifications](/desktop/use/notifications/)
- [Quick settings](/desktop/use/quick-settings/)
- [Files](/desktop/use/files/)
- [Network, Wi-Fi and Bluetooth](/desktop/settings/network-wifi-bluetooth/)
