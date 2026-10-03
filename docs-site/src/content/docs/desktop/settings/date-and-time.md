---
title: Date and time
description: Set the time zone, choose automatic or manual time, change the clock format and learn which time servers Nubo OS uses.
sidebar:
  order: 110
---

**Applies to:** Desktop

This page shows how to set the date, time and time zone on Nubo OS. It also explains where the computer gets the time from, which differs from a stock Ubuntu installation.

## Before you begin

- Changing the time zone or time manually needs an administrator account. You may be asked for your password.
- Automatic time needs an internet connection.

## Set the time zone

1. Open [Settings](/desktop/settings/) and go to the date and time page. <!-- verify label -->
2. Turn on automatic time zone if you want it to follow your location. This needs location services. See [Privacy and security](/desktop/settings/privacy-and-security/).
3. Or turn it off and choose a time zone by searching for a city.

## Automatic date and time

Leave **Automatic Date & Time** on to keep the clock accurate. <!-- verify label --> Nubo OS sets the time servers in `/etc/systemd/timesyncd.conf.d/`:

| Setting | Value |
|---|---|
| Primary server | `time.cloudflare.com` |
| Fallback | `pool.ntp.org` |

These replace Ubuntu's own time servers. The Nubo project describes the Cloudflare server as using NTS (network time security). The time service on the desktop is `systemd-timesyncd`, which Nubo configures; on servers `chrony` is used. <!-- verify label: whether timesyncd on the desktop uses NTS is not confirmed in the repo -->

## Set the time by hand

1. On the date and time page, turn off automatic date and time.
2. Click the date or the time and enter the values.

Setting the time by hand is useful offline or in a virtual machine with no network.

## Clock format

On the same page, choose a 24 hour or an AM/PM clock. <!-- verify label --> You can also choose to show the weekday, the date or seconds in the top bar. <!-- verify label: some of these options may be in the Calendar settings --> The Nubo clock widget on the desktop shows the time and date. See [Desktop widgets](/desktop/use/widgets/).

## World clocks

Click the date in the top bar and choose **Add World Clocks...** to show the time in other cities in the calendar panel. The Clocks app, in the Accessories folder, also keeps world clocks, alarms and timers.

## Verify

1. Run `timedatectl`. It shows the local time, the time zone, and whether the clock is synchronized.
2. Run `timedatectl show-timesync --all | grep -i -E "ServerName|SystemNTPServers"` to see the time servers in use. <!-- verify label: output fields -->
3. The time in the top bar matches a trusted clock.

## Troubleshooting

**The time is wrong by a few hours.**
Cause: wrong time zone. Fix: choose the correct one.

**The time is wrong by minutes and does not fix itself.**
Cause: no network or the server is blocked by a firewall. Fix: check the connection; if your network blocks time servers, set the time by hand or ask your network administrator about allowing NTP traffic.

**"Automatic date and time" is off or greyed out.**
Cause: the time service is not running, or you do not have permission. Fix: unlock the page. Run `timedatectl status` to check.

**The clock is an hour off in spring or autumn.**
Cause: the time zone data is out of date or the wrong zone. Fix: install updates and choose the right zone for your region.

**Dual boot with Windows shows the wrong time.**
Cause: Windows stores local time in the hardware clock, Linux stores UTC. Fix: run `timedatectl set-local-rtc 1 --adjust-system-clock` as an alternative, or set Windows to use UTC. Check Ubuntu's documentation before changing.

## See also

- [Language and region](/desktop/settings/language-and-region/)
- [Desktop widgets](/desktop/use/widgets/)
- [Privacy and security](/desktop/settings/privacy-and-security/)
- Ubuntu's documentation: https://ubuntu.com/desktop/docs
