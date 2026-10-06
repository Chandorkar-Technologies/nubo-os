# Nubo account provider for GNOME Online Accounts

> **Status.** The desktop does not need this patch. Evolution's data server (which
> feeds Geary, Calendar and Contacts and keeps their offline copy) only accepts the
> standard account types and ignores `nubo`. Nubo Setup therefore adds the account
> with `account/nubo-goa-add`: a standard IMAP/SMTP account and a standard WebDAV
> account, tested against the real server. This patch would only add a "Nubo" entry
> to Settings > Online Accounts, and it would also need a patch for
> evolution-data-server to be useful.


Adds a **Nubo** provider to GNOME Online Accounts (GOA). In Settings > Online
Accounts a person picks Nubo, types their Nubo email address and password, and
GOA configures all of this against one host, `mail.nubo.email` (Stalwart):

| Service  | Protocol        | Endpoint                                            |
|----------|-----------------|-----------------------------------------------------|
| Mail     | IMAP (TLS)      | `mail.nubo.email:993`                               |
| Mail     | SMTP (TLS)      | `mail.nubo.email:465`, PLAIN auth, same credentials |
| Calendar | CalDAV          | `https://mail.nubo.email/dav/cal`                   |
| Contacts | CardDAV         | `https://mail.nubo.email/dav/card`                  |
| Files    | WebDAV (GVfs)   | `davs://mail.nubo.email/dav/file`                   |

The login name is the full email address (also for custom domains) and one
password is used for everything. In the account's page in Settings, Mail,
Calendar, Contacts and Files are each a toggle.

## Contents

```
goa/
  README.md
  build-goa.sh                  fetch Ubuntu's source, apply the patch, build .debs
  build-control-center.sh       optional: same for gnome-control-center (see "Order")
  icons/goa-account-nubo.svg    provider icon (also contained in the patch)
  out/                          the .debs built on the dev VM (arm64), 3.58.0-1+nubo1
  tests/                        fake server + dialog driver used for verification
                                (fakeserver.py, drive.c, run-drive.sh, list.c)
  patches/
    nubo-provider.patch                    against gnome-online-accounts 3.58.0-1 (-p1)
    gnome-control-center-nubo-first.patch  one line, against gnome-control-center 50.3 (-p1)
```

## What the GOA patch does

Quilt patch `debian/patches/nubo-provider.patch`, version suffix `+nubo1`
(`3.58.0-1+nubo1`, which sorts above `3.58.0-1` and `3.58.0-1ubuntu0.1`).

* `src/goabackend/goanuboprovider.[ch]` (new): `GoaNuboProvider`, a subclass of
  `GoaWebDavProvider`. The base class already owns the CalDAV/CardDAV/WebDAV
  services, the `PasswordBased` D-Bus interface and the DAV credential check.
  The subclass adds:
  * provider type `nubo`, name "Nubo", `GOA_PROVIDER_GROUP_BRANDED`, features
    Mail + Calendar + Contacts + Files (+ the BRANDED feature bit, like Google);
  * the Mail service (`GoaMail`, IMAP + SMTP) attached in `build_object()` the
    same way `GoaImapSmtpProvider` does, with its own `MailEnabled` toggle key;
  * a two-field sign-in dialog (Email Address, Password). On "Sign In" the
    credentials are checked in a worker thread with the existing helpers
    (`goa_mail_client_check_sync` for IMAP and SMTP,
    `goa_dav_client_check_sync` for CalDAV, CardDAV, WebDAV). Only if all pass
    is the account created through `Manager.AddAccount`, with Mail, Calendar,
    Contacts and Files all enabled;
  * keyring credentials `password`, `imap-password` and `smtp-password` (all the
    same value), so Evolution (`imap-password`/`smtp-password`), gvfs and
    evolution-data-server (`password`) each find what they ask for;
  * `ensure_credentials_sync()`: the DAV check of the base class, then an
    IMAP + SMTP login. A rejected password comes back as `NotAuthorized`, which
    makes GOA flag the account "attention needed" so Settings offers "Sign In";
  * `refresh_account()`: the password-only sign-in dialog for that case.
* `goaprovider.c`: `GOA_NUBO_ENABLED` entry placed first in
  `ordered_builtins_map`. The type is registered with extension priority -1,
  because `goa_provider_get_all()` returns extensions by ascending priority and
  the WebDAV base class always registers before its subclasses; with priority
  -1 Nubo is really first in the list (verified, see below).
* `meson.build`, `meson_options.txt`: `-Dnubo=true` (default), `GOA_NUBO_NAME`,
  `GOA_NUBO_ENABLED`, entry in the provider summary.
  `src/goabackend/meson.build`: source added. `data/icons/meson.build` +
  `data/icons/scalable/goa-account-nubo.svg`: the icon, installed to
  `hicolor/scalable/apps/` by the `gnome-online-accounts` package.
  `po/POTFILES.in`: new source file.
* `goa_nubo_provider_get_type` is `G_GNUC_INTERNAL`, so the library exports no new
  symbol and `debian/libgoa-backend-1.0-2.symbols` needs no change.
* No user-visible string of the provider mentions another brand.

### Pointing it at a test server

Read by the process that shows the dialog (gnome-control-center or any client of
`libgoa-backend`); the daemon later uses the hosts stored in `accounts.conf`.

* `NUBO_GOA_HOST=host` in the environment, or
* `/etc/goa.conf`:
  ```
  [nubo]
  Host=test.example.org
  ```
* Certificate errors are accepted **only** when the host is overridden and
  `NUBO_GOA_ACCEPT_SSL_ERRORS=1` (or `AcceptSslErrors=true` in `[nubo]`) is set.
  For `mail.nubo.email` certificates are always verified.
* If `/etc/goa.conf` restricts providers (`[providers] enable=...`), add `nubo`.

## Order in Settings (important)

`goa_provider_get_all()` and the builtin table put Nubo first, **but
gnome-control-center 50 ignores that order**. In
`panels/online-accounts/cc-online-accounts-panel.c`, `goa_provider_priority()`
sorts providers with a hard-coded list (`google`, `ms_graph`, `exchange`,
`owncloud`, `fedora`, `imap_smtp`, `webdav`, `kerberos`) and puts **unknown types
last**. Without a gnome-control-center change Nubo is listed at the bottom.

`patches/gnome-control-center-nubo-first.patch` adds `"nubo"` at the top of that
list. `build-control-center.sh` builds a patched gnome-control-center
(`50.3-0ubuntu0.2+nubo1`) the same way as GOA. Both packages have to be shipped
for Nubo to be first in the UI.

## Building

On the Ubuntu 26.04 machine, as the normal user (sudo is used for
`apt-get build-dep` and, once, to enable `deb-src`):

```
cd goa
./build-goa.sh            # .debs in ./out
sudo apt-get install ./out/libgoa-1.0-common_*.deb ./out/libgoa-1.0-0b_*.deb \
    ./out/libgoa-backend-1.0-2_*.deb ./out/gnome-online-accounts_*.deb \
    ./out/gir1.2-goa-1.0_*.deb
```

Install `gir1.2-goa-1.0` too if it is installed, so versions stay consistent.
Restart the daemon (`pkill goa-daemon`, it is D-Bus activated) or log in again.

Optional, for the Settings order:

```
sudo apt-get install ./out/libgoa-1.0-dev_*.deb ./out/libgoa-backend-1.0-dev_*.deb   # build-dep needs them
./build-control-center.sh   # .debs in ./out-control-center
sudo apt-get install ./out-control-center/gnome-control-center_*.deb ./out-control-center/gnome-control-center-data_*.deb \
    ./out-control-center/gnome-control-center-faces_*.deb
```
(install whichever gnome-control-center* packages are already installed).

Environment knobs for both scripts: `WORK`, `OUT`, `PATCH`, `SUFFIX`, `JOBS`,
`SKIP_BUILD_DEP=1`, `DEB_BUILD_OPTIONS=nocheck`.

## When Ubuntu updates GOA or gnome-control-center

1. Run `./build-goa.sh`. It fetches the **current** source with `apt-get source`,
   checks `patch --dry-run`, and stops with a message if the patch no longer
   applies. The new version becomes `<ubuntu version>+nubo1`
   (e.g. `3.58.0-1ubuntu0.1+nubo1`).
2. If it does not apply (usually after an upstream bump such as 3.59):
   `apt-get source gnome-online-accounts`, copy `goanuboprovider.[ch]` and the
   icon from the old patch, redo the small edits in `meson.build`,
   `meson_options.txt`, `src/goabackend/meson.build`, `goaprovider.c`,
   `data/icons/meson.build`, `po/POTFILES.in`, regenerate the patch
   (`diff -ruN a b`) and replace `patches/nubo-provider.patch`. Watch for
   API changes in `GoaWebDavProvider` (`goawebdavprovider-priv.h`), `GoaProviderDialog`
   and the mail/DAV clients: those are the only internal APIs the provider uses.
3. Check the debian packaging step: a new `debian/*.symbols` entry is only needed
   if the library gains symbols (the provider adds none).
4. Install the new `.deb`s, update the pin (next section) if the version changed.
5. Same for gnome-control-center with `./build-control-center.sh`.

Bump `SUFFIX` (`+nubo2`) when only the patch changes on an unchanged Ubuntu
version, otherwise apt will not see an upgrade.

## apt pin

So Ubuntu's own updates do not silently replace the patched packages, create
`/etc/apt/preferences.d/nubo-goa`:

```
Package: gnome-online-accounts libgoa-1.0-0b libgoa-1.0-common libgoa-1.0-dev libgoa-1.0-doc libgoa-backend-1.0-2 libgoa-backend-1.0-dev gir1.2-goa-1.0
Pin: version 3.58.0-1+nubo1*
Pin-Priority: 1001
```

and, if the control-center patch is used:

```
Package: gnome-control-center gnome-control-center-data gnome-control-center-faces
Pin: version 1:50.3-0ubuntu0.2+nubo1*
Pin-Priority: 1001
```

Notes:

* Priority 1001 also permits downgrades to the pinned version. It only matters
  when the pinned version is available to apt: put the `.deb`s in the Nubo apt
  repository (or a local one) that the image uses; the pin does not install
  anything by itself.
* A pin with a wildcard keeps matching `3.58.0-1+nubo1` but **not**
  `3.58.0-1ubuntu0.1+nubo1`; update it with every rebuild.
* While pinned, Ubuntu security fixes in these packages are not picked up until
  you rebuild. Watch `apt-get changelog gnome-online-accounts` /
  `rmadison gnome-online-accounts` and rebuild when it changes.
* `libgoa-1.0-dev`/`libgoa-backend-1.0-dev` from Ubuntu require the exact
  `libgoa-1.0-0b` version, so a machine with the patched runtime needs the
  patched `-dev` packages for any build that uses them (e.g. building
  gnome-control-center).

## Known limits

* **A successful login against the real server is untested.** No Nubo
  credentials were available. Verified: wrong credentials against
  `mail.nubo.email` give a clean error (TLS and IMAP connect and reject), and the
  full add flow, keyring storage and `EnsureCredentials` against a local fake
  server (see "Verification").
* DAV paths were taken from the server description. Whether GVfs shows
  `davs://.../dav/file` the way a user expects (root versus a per-user folder),
  and how evolution-data-server discovers calendars and address books below
  `/dav/cal` and `/dav/card` (it should, via `current-user-principal` or
  `.well-known`), is untested. If Stalwart needs `/dav/cal/<user>/`, change the
  three `NUBO_PATH_*` defines in `goanuboprovider.c`.
* Stalwart answers a DAV `OPTIONS` request without credentials, so the DAV checks
  confirm only that the endpoints exist; the password is verified by the IMAP and
  SMTP logins, which therefore run first (and also in `EnsureCredentials`).
* One password, no OAuth, no second factor: an account with two-factor
  authentication needs an app password.
* The mail display name defaults to the local user's real name (`g_get_real_name()`),
  editable in the mail client. There is no "Name" field in the dialog.
* Provider-specific strings are not translated (no `.po` files); they fall back to
  English.
* No symbolic icon variant (`goa-account-nubo-symbolic`), so GOA falls back to the
  generic symbolic account icon where a symbolic icon is requested.
* Only `3.58.x` was built and tested, on arm64.

## Verification done (Ubuntu 26.04 arm64, GNOME 50, goa 3.58.0-1+nubo1)

* Build with `build-goa.sh`: no warnings in `goanuboprovider.c`; the new symbol is
  not exported; the icon is in `gnome-online-accounts`.
* Packages installed, `goa-daemon` restarted, no warnings or errors in
  `journalctl --user`.
* `goa_provider_get_all()` returns `nubo` first.
* Real dialog run under Broadway with a small test program that fills the entry
  rows and activates the default button: wrong password gives the banner
  "The email address or password is incorrect" (against both a local fake server
  and `mail.nubo.email` with a nonexistent account); correct password adds the
  account with Mail, Calendar, Contacts and Files interfaces, URIs as above and all
  three keyring passwords retrievable through `GetPassword`; each of the four
  toggles removes and restores its interface; `EnsureCredentials` succeeds, then
  returns `NotAuthorized` after the server password changes.
* Not verified: how it looks in Settings (no screen access), the position in the
  Settings list (needs the gnome-control-center patch, which was built but not
  installed), real login, and calendar, contacts and files actually syncing.
