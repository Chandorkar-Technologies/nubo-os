---
title: Users and profile picture
description: Add and manage accounts, change your profile picture, and learn how the default Nubo avatar is chosen.
sidebar:
  order: 100
---

**Applies to:** Desktop

This page covers user accounts and the picture shown for you on the login screen. Nubo OS adds one behavior: if you have not chosen a picture, you get a default Nubo avatar instead of a grey silhouette.

## The default avatar

The default picture is the Nubo mark on an orange gradient disc. It is stored in `/usr/share/nubo/avatar.png`.

It is applied in two places:

1. **At first boot after installation.** A one-time job gives the picture to the accounts the installer created, by copying it to `.face` in the home folder and telling the system's account service about it. It skips any account that already has a `.face` file.
2. **At every login.** The session helper checks for `~/.face`. If the file does not exist, it copies the avatar there and registers it. If you already have `~/.face`, nothing happens.

So the default only fills in a missing picture. It never replaces one you chose.

:::note
If you delete `~/.face`, the default avatar comes back at your next login. To keep another picture, replace the file or set a picture in Settings; do not delete it.
:::

## Before you begin

- To add, remove or change other accounts, you need an administrator account.
- To change your own picture, you only need to be logged in.

## Change your profile picture

1. Open [Settings](/desktop/settings/) and go to the users page. <!-- verify label -->
2. Click your picture.
3. Choose a picture from the list, take one with a camera, or browse for a file.
4. Confirm.

The new picture shows in the login screen and in places that read your account picture.

## Add a user

1. On the users page, click to unlock it and enter your password. <!-- verify label -->
2. Click the button to add a user.
3. Enter the name and choose a password, or let the person set it at first login.
4. Choose whether the new account is a standard account or an administrator.

The new user gets the default Nubo avatar at their first login.

## Change a password or remove an account

- To change your own password, use the password option on the users page.
- To remove an account, an administrator unlocks the page, selects the account and uses the remove option. Choose whether to keep the files.

## Nubo account sign-in

:::caution[Early access]
Signing in at the login screen with a Nubo account is early access. It uses the `nubo-account` package and the authd-oidc broker, which is distributed as a snap. Do not rely on it as your only way to log in. Keep a local account.
:::

A Nubo provider for GNOME Online Accounts also exists. It is a preview, tested only against a test server, and is not installed by default.

## Verify

1. Log out. The login screen shows your picture. A new account without a picture shows the Nubo avatar.
2. Run `ls -l ~/.face`. The file exists.
3. On the users page, your picture matches the login screen.

## Troubleshooting

**The login screen shows a grey silhouette.**
Cause: the account has no picture registered. Fix: log in once, since the session helper adds it, or choose a picture in Settings.

**My own picture came back as the Nubo avatar.**
Cause: `~/.face` was removed. Fix: set your picture again in Settings.

**The picture does not update on the login screen.**
Cause: the account service has not reloaded. Fix: log out and in, or restart the computer.

**I cannot add users.**
Cause: your account is not an administrator. Fix: ask an administrator.

## See also

- [Privacy and security](/desktop/settings/privacy-and-security/)
- [Light and dark appearance](/desktop/use/light-and-dark/)
- Ubuntu's documentation: https://ubuntu.com/desktop/docs
