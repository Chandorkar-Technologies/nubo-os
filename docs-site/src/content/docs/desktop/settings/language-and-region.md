---
title: Language and region
description: Change the system language, date and number formats, and install language support with the Languages app.
sidebar:
  order: 90
---

**Applies to:** Desktop

Language and region settings decide which language menus appear in, and how dates, numbers and currency are written. Nubo OS uses the same system as Ubuntu 26.04 LTS. This page shows how to change them and what is not translated yet.

:::caution[Planned]
Nubo's own pieces are in English only for now: the Nubo menu text, the Nubo notification center, Nubo Search's Nubo settings and the Nubo guides. Translations are planned and not built yet. Apps from Ubuntu and GNOME keep their own translations.
:::

## Before you begin

- An internet connection, if the language needs to be downloaded.
- Administrator rights, to install language support for all users.

## Change the language

1. Open [Settings](/desktop/settings/) and go to the page for language and region. <!-- verify label -->
2. Under language, choose yours. If it is missing, choose the option to manage installed languages. This opens the Languages app (see below).
3. Click **Restart**, or log out and in, to apply it. The change affects menus and apps from the next login.

## Change formats

The region setting changes date, time, number, currency and measurement formats without changing the language. Pick a region on the same page. <!-- verify label --> For example, you can have English menus with European date formats.

## The Languages app

Nubo OS has an app called **Languages**, shown in the app grid and in the Utilities folder. It is GNOME's language support tool, renamed. It checks which language packs are missing and offers to install them: translations, spell checking dictionaries and fonts. <!-- verify label: description of what the tool installs -->

1. Open Languages from the app grid.
2. If it says language support is incomplete, confirm the installation.
3. Choose your language, and use the option to apply it system-wide if you want the login screen to use it as well. <!-- verify label -->

## Fonts

The desktop installs Noto fonts for many scripts (including Chinese, Japanese and Korean through Noto CJK and color emoji), Inter as the interface font and JetBrains Mono as the monospace font.

## Input methods

For languages with their own input method, add an input source on the keyboard page. See [Keyboard and input](/desktop/settings/keyboard-and-input/).

## The installer language

The installer asks for your language when you install. It sets the first language and keyboard. The installer's screens are Ubuntu's, with Nubo branding.

## Verify

1. Log out and in. Menus in GNOME apps are in the new language.
2. Run `echo $LANG` in a terminal. It prints the locale, for example `de_DE.UTF-8`.
3. In the Settings page for formats, the preview shows the format you chose. <!-- verify label -->

## Troubleshooting

**Parts of the screen stay in English.**
Cause: no translation exists for that part (see the note above), or language support is incomplete. Fix: open Languages and install missing support.

**The login screen is still in the old language.**
Cause: the login screen has its own language. Fix: use the option in Settings or Languages to apply it system-wide.

**Characters appear as empty boxes.**
Cause: a missing font. Fix: install the fonts for the script with Languages, or `sudo apt install fonts-noto-core`.

**Dates are in the wrong format.**
Cause: the region differs from the language. Fix: choose the region again.

## See also

- [Keyboard and input](/desktop/settings/keyboard-and-input/)
- [Date and time](/desktop/settings/date-and-time/)
- Ubuntu's documentation: https://ubuntu.com/desktop/docs
