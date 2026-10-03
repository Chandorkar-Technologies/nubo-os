---
title: Account security
description: How your Nubo account passwords, recovery codes and sign-in tokens are handled on the desktop.
sidebar:
  order: 90
---

**Applies to:** Desktop

This page describes what the Nubo account code on your computer does with your secrets. It lists what is stored, where, and what you should do to stay safe. It describes what the code does today and makes no claim that it is secure against any kind of attack.

## Passwords

- **Account creation:** the Nubo Setup window asks for a password of at least eight characters. It sends it to Nubo's sign-up service at `https://admin.nubo.email`. It does not keep it.
- **Mail, calendar, contacts and files:** if you use the Nubo provider in [Online Accounts](/desktop/account/online-accounts/), the password is stored in your login keyring (GNOME Keyring). It is stored three times under the names `password`, `imap-password` and `smtp-password`, so that different programs can find the one they ask for.
- **One password, no second factor:** the provider uses only a password. There is no OAuth and no second factor in it. If your account has two-factor authentication, an app password is needed.

## Recovery codes

When Nubo Setup creates an account, the server returns a list of recovery codes. The window says each one works once, if you lose your phone or password, and asks you to save them before you continue.

- Write them down or put them in a password manager. They are shown in the window and are not kept by the desktop.
- Use each code once. After use it no longer works.
- Anyone who has a code can use it. Keep them private.

The desktop has no screen that shows the codes again or makes new ones. Treat the first view as the only one. <!-- verify: regeneration of recovery codes -->

## Sign-in tokens

The device-flow sign-in (Nubo Setup, and the login screen) gives the computer tokens instead of using a typed password.

| What | Where it is kept |
|---|---|
| Refresh token | Your login keyring. Item label "Nubo account", with the attributes `service` = `nubo-account` and `kind` = `refresh-token`. Saved with `secret-tool` (package `libsecret-tools`). |
| Your email address and the server address | `~/.config/nubo/account.json`. This folder is created with permission 700 (only you). The file holds no secret. |
| A marker that setup ran | `~/.config/nubo/setup-done` |
| Connector configuration for the login screen | `/var/snap/authd-oidc/current/broker.conf`, written with umask 077, so only root can read it. It holds the server address and the client name, no password. |

The refresh token lets the session be renewed without signing in again each time. The sign-in asks for the `offline_access` scope for that reason.

Because the refresh token is in the login keyring, it is protected by your login password. If your keyring is unlocked automatically (for example by automatic login), anyone who can use your session can read it.

## Who can administer the machine

With sign-in at the login screen, the first Nubo account to sign in is the owner and is added to the `sudo` and `lpadmin` groups. Others are refused until the owner allows them. See [Sign in at the login screen](/desktop/account/sign-in-at-the-login-screen/).

## What you should do

1. Use a strong, unique password for the Nubo account.
2. Save the recovery codes when you create the account.
3. Keep a local user password on the computer, in addition to the Nubo sign-in, while sign-in is early access.
4. Lock the screen when you leave. A locked session keeps the keyring protected from other people.
5. If you lose a device, change your Nubo password on another device.

## Report a problem

For a security issue in Nubo OS, write to security@nubosuite.tech. For other questions, write to support@nubo.email.

## See also

- [What is a Nubo account?](/desktop/account/what-is-a-nubo-account/)
- [Updates](/updates/)
