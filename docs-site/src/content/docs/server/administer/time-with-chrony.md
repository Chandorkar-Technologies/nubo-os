---
title: Time with chrony
description: Check time synchronization on Nubo OS Server, understand the Cloudflare NTS and pool.ntp.org sources, and add your own time servers.
sidebar:
  order: 50
---

**Applies to:** Server, Virtualization, Containers, Edge

Correct time matters on a server: TLS certificates, log timestamps, package signatures and Kerberos all depend on it. Nubo OS Server keeps time with chrony, which `nubo-server-core` installs. The package `nubo-base` replaces Ubuntu's default time servers with two Nubo has chosen.

## What Nubo sets up

`nubo-base` puts this file in place of Ubuntu's list of time sources:

```text title="/etc/chrony/sources.d/ubuntu-ntp-pools.sources"
# Nubo OS time servers (replace Ubuntu's ntp.ubuntu.com pools).
pool time.cloudflare.com iburst maxsources 2 nts
pool pool.ntp.org iburst maxsources 3
```

| Part | Meaning |
|---|---|
| `pool` | A name that resolves to one or more servers; chrony picks up to `maxsources` of them. |
| `time.cloudflare.com ... nts` | Cloudflare's time service, used with **Network Time Security (NTS)**. NTS authenticates the time source with TLS, so a machine on the path cannot hand you a false time without being detected. |
| `pool.ntp.org` | The public NTP pool, for plain (unauthenticated) time. |
| `iburst` | Send a quick burst of requests at start so the clock settles faster. |
| `maxsources 2` / `3` | Use at most two Cloudflare servers and three pool servers. |

The file name is Ubuntu's (`ubuntu-ntp-pools.sources`); Nubo keeps Ubuntu's original beside it as `ubuntu-ntp-pools.sources.ubuntu`. The `nubo-base` package rewrites this file each time it is configured (for example during an upgrade), so do not edit it. Add your own files instead (below).

NTS uses TCP port 4460 to set up keys, then UDP port 123 for time. Both are outgoing connections, which the default firewall allows. If you filter outgoing traffic, allow them.

For machines that use `systemd-timesyncd` instead of chrony, `nubo-base` also installs `/etc/systemd/timesyncd.conf.d/nubo-timesyncd.conf` with `NTP=time.cloudflare.com` and `FallbackNTP=pool.ntp.org`. On Nubo OS Server chrony is installed, and timesyncd steps aside when chrony is present, so that file normally has no effect. <!-- verify: timesyncd inactive when chrony is installed on 26.04 -->

## Before you begin

- Logged in as a user with `sudo`.
- Outgoing access to port 4460/TCP and 123/UDP.

## Steps

### Check the time status

```bash
timedatectl
chronyc tracking
chronyc sources -v
```

`timedatectl` shows the time zone and whether the clock is synchronized. `chronyc tracking` shows how far the clock is from the reference. `chronyc sources -v` lists each source and its state.

### Check that NTS is working

```bash
sudo chronyc -N authdata
```

For `time.cloudflare.com` you should see the mode `NTS` and a non-zero count of keys. The `-N` option makes chrony print names instead of addresses.

### Set the time zone

```bash
timedatectl list-timezones | grep Kolkata
sudo timedatectl set-timezone Asia/Kolkata
```

Use your own region and city. The installer does not set the time zone from a location lookup (it has geo-IP turned off), so check this once.

### Add your own time server (for example inside a company network)

Add a separate file in the same directory. chrony reads every `.sources` file there.

```text title="/etc/chrony/sources.d/local.sources"
server ntp.example.com iburst
```

Then tell chrony to re-read its sources:

```bash
sudo chronyc reload sources
```

### Step the clock now (rarely needed)

If the clock is badly wrong at boot, make chrony correct it at once:

```bash
sudo chronyc makestep
```

## Verify

```bash
chronyc tracking | grep -E 'Reference ID|Leap status|System time'
```

```text
Reference ID    : A29FC801 (time.cloudflare.com)
System time     : 0.000012345 seconds fast of NTP time
Leap status     : Normal
```

The values are an example. `Leap status : Normal` and a reference of a real time server mean the clock is synchronized. `chronyc sources` shows a `*` next to the source in use.

## Troubleshooting

**`chronyc: 506 Cannot talk to daemon`.** chrony is not running. Run `systemctl status chrony` and `sudo systemctl restart chrony`.

**`Leap status : Not synchronised`.** The server has just started, or cannot reach any source. Wait a minute, then check `chronyc sources`. If every source shows `?`, test outgoing UDP 123 and DNS (`resolvectl query pool.ntp.org`).

**Cloudflare shows no NTS keys in `authdata`.** Key setup uses TCP 4460, which a firewall or proxy may block. The machine still gets time from `pool.ntp.org`, but without authentication. Allow outgoing 4460/TCP. A wrong system date can also make the TLS handshake fail: use `sudo chronyc makestep` or set the date once by hand.

**In a virtual machine the clock drifts after suspend.** Many hypervisors expose a clock device that chrony can use. See Ubuntu's chrony documentation for the `refclock` options.

## See also

- [First boot checklist](/server/install/first-boot-checklist/)
- [What contacts the internet](/server/security/what-contacts-the-internet/)
- [Ubuntu: time synchronization with chrony](https://ubuntu.com/server/docs/how-to/networking/chrony-client/)
