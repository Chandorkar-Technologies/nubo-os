---
title: Network, Wi-Fi and Bluetooth
description: Connect to Wi-Fi and wired networks, add a VPN, and pair Bluetooth devices.
sidebar:
  order: 30
---

**Applies to:** Desktop

Networking on Nubo OS is handled by NetworkManager, with GNOME's panels on top. Bluetooth uses BlueZ. Nubo does not change how either works. This page shows the common tasks and the Nubo-specific points.

## Before you begin

- For Wi-Fi: a Wi-Fi adapter and the network's name and password.
- For Bluetooth: a Bluetooth adapter. The desktop recommends `bluez` and the Bluetooth audio support for PipeWire.
- On first boot, Nubo OS downloads some apps from Flathub, which needs an internet connection. See [Dock and app grid](/desktop/use/dock-and-app-grid/).

## Connect to Wi-Fi

1. Open [quick settings](/desktop/use/quick-settings/).
2. Click the arrow on the network tile. It is named **Wired** when you are on a cable and shows Wi-Fi when you have a wireless adapter. <!-- verify label: Wi-Fi tile name -->
3. Pick your network and enter the password.

Or use the network page in [Settings](/desktop/settings/). <!-- verify label --> Hidden networks, static addresses and proxy settings are there too.

## Wired connections

A cable usually connects by itself. The **Wired** tile in quick settings shows it. In Settings you can set a fixed IP address, DNS servers or a proxy for the wired connection. <!-- verify label -->

## Add a VPN

The desktop recommends the NetworkManager plug-ins for OpenVPN and PPTP. WireGuard support is built into NetworkManager.

1. Open the network page in Settings and add a VPN. <!-- verify label -->
2. Choose the type and enter the details your provider gave you, or import a configuration file.
3. Switch the VPN on from quick settings.

The advanced connection editor (`nm-connection-editor`) is hidden from the launcher on Nubo OS, but it is still installed and can be started from a terminal.

## Airplane mode

If your computer has wireless hardware, quick settings may offer an Airplane Mode tile that switches off Wi-Fi and Bluetooth. <!-- verify label -->

## Pair a Bluetooth device

1. Put the device in pairing mode.
2. Open the Bluetooth page in Settings, or the Bluetooth tile in quick settings. <!-- verify label -->
3. Make sure Bluetooth is on and choose your device in the list.
4. Confirm the code if one appears on both screens.

Paired audio devices appear as outputs or inputs in [Sound](/desktop/settings/sound/). To send a file to a phone over Bluetooth, the desktop recommends `gnome-bluetooth-sendto`. For other transfers see [Phone link](/desktop/use/phone-link/).

## Network checks that Nubo OS makes

To decide if the computer is online, Nubo OS asks a Nubo address (`archive.nubosuite.tech/check`) instead of Canonical's connectivity check. The computer's clock uses `time.cloudflare.com` and `pool.ntp.org`. See [Date and time](/desktop/settings/date-and-time/).

## Verify

1. The top bar shows a network icon in the status area.
2. Open a web page in Firefox.
3. For Bluetooth, the device shows as connected in the list.

## Troubleshooting

**The Wi-Fi network is not in the list.**
Cause: out of range, hidden, or Wi-Fi is off or blocked. Fix: turn Wi-Fi on, check airplane mode, move closer. For a hidden network use the connect to hidden network option in Settings. <!-- verify label -->

**It connects but there is no internet.**
Cause: a login page (captive portal), wrong DNS or no route. Fix: open a browser and look for a login page. Check the connection details in Settings. The Nubo connectivity check uses the Nubo address above.

**No Wi-Fi adapter appears.**
Cause: missing driver or firmware. Fix: install updates and restart; if the adapter still does not show, check the Additional Drivers or Software settings. <!-- verify label -->

**A Bluetooth device will not pair.**
Cause: not in pairing mode, or an old pairing. Fix: remove the device in Settings, put it in pairing mode again and retry.

## See also

- [Quick settings](/desktop/use/quick-settings/)
- [Sound](/desktop/settings/sound/)
- [Phone link](/desktop/use/phone-link/)
- Ubuntu's documentation: https://ubuntu.com/desktop/docs
