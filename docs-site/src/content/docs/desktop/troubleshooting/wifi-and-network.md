---
title: Wi-Fi and network problems
description: Fix a missing Wi-Fi adapter, a connection with no internet, or downloads that do not start.
sidebar:
  order: 40
---

**Applies to:** Desktop

Nubo OS uses NetworkManager and `wpasupplicant` for networking, as Ubuntu does. Several Nubo jobs need the network: the first-boot app downloads, the Nubo account setup and the grey app icons. They retry on later boots, so fixing the network usually fixes them too.

## Before you begin

- Know whether you use Wi-Fi or a cable.
- If you have a cable, plug it in. It is the quickest way to test. Wired shows as "Wired" in the quick settings menu.
- You can open a terminal.

## Steps

### 1. Look at the quick settings

Click the status icons at the top right. The tile at the left of the first row shows your network. Click its arrow to see the networks you can join.

![Quick settings with the Wired network tile](../../../../assets/screens/quick.jpg)

### 2. Check that Wi-Fi is not switched off

Some laptops have a keyboard key or switch that turns radios off.

```bash
rfkill list
```

If the output says `Soft blocked: yes` or `Hard blocked: yes`, unblock it:

```bash
rfkill unblock wifi
```

A hard block means a physical switch or key. Use it.

### 3. Check that the adapter exists

```bash
nmcli device status
```

A Wi-Fi adapter shows as `wifi`. If none is listed, check the hardware:

```bash
lspci -nnk | grep -iA3 net
lsusb
```

If the line says no driver is in use, the adapter may need a driver that Ubuntu supplies separately. Ubuntu's Additional Drivers tool (`ubuntu-drivers`) is installed on Nubo OS:

```bash
sudo ubuntu-drivers list
```

Connecting by cable or through your phone's USB tethering lets you download a driver.

### 4. Join the network

```bash
nmcli device wifi list
nmcli device wifi connect "Your network name" --ask
```

### 5. Test the connection

```bash
ping -c 3 1.1.1.1
ping -c 3 archive.nubosuite.tech
```

- If the first works and the second fails, the problem is name lookup (DNS) or a firewall that blocks Nubo.
- If both fail, the connection has no internet. Restart the router, or ask your network owner.

### 6. Test the archive

Nubo's package archive has a network check page:

```bash
curl -I https://archive.nubosuite.tech/check
```

If `curl` returns a status line, the network can reach Nubo. If the archive is unreachable but the rest of the internet works, you can send Ubuntu's traffic to Ubuntu directly. See [Updates](/updates/) for opting out of Nubo Cumulus.

### 7. Check the time

Time that is far off breaks secure connections. Nubo OS gets the time from `time.cloudflare.com` and `pool.ntp.org`.

```bash
timedatectl
```

The line "System clock synchronized" should say `yes`.

## Verify

1. The quick settings tile shows your network name.
2. `ping -c 3 archive.nubosuite.tech` succeeds.
3. Restart the computer, wait a few minutes, and check that apps from the first boot appear if they were missing.

## Troubleshooting

- **The network is connected but pages do not load.** Run the two `ping` tests in step 5. A captive portal (a Wi-Fi login page in hotels or cafés) can block traffic until you sign in through a browser.
- **Wi-Fi disappears after suspend.** Restart NetworkManager: `sudo systemctl restart NetworkManager`.
- **A VM has no network.** Check the VM's network adapter in the host tool. A NAT adapter is the simplest.
- **Only Nubo downloads fail.** The cause may be a firewall or proxy that blocks `archive.nubosuite.tech`. Allow it, or opt out of Cumulus.
- **Still stuck.** See [Collect logs for support](/desktop/troubleshooting/collect-logs-for-support/).

## See also

- [Apps not opening](/desktop/troubleshooting/apps-not-opening/)
- [Getting help](/start/getting-help/)
- [Ubuntu Desktop documentation](https://ubuntu.com/desktop/docs)
