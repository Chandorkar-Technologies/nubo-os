#!/usr/bin/env bash
# Let people sign in to this machine with their Nubo account.
#
# Uses Ubuntu's authd with its generic OIDC connector, pointed at Nubo SSO.
# Sign-in uses the device flow: the login screen shows a short code and a web
# address (also as a QR code); the person approves on their phone or another
# computer, and the desktop session opens.
#
# Run as root on an installed Nubo OS machine with network access.

set -euo pipefail

ISSUER="${ISSUER:-https://mail.nubo.email}"
CLIENT_ID="${CLIENT_ID:-nubo-os}"
BROKER_CONF=/var/snap/authd-oidc/current/broker.conf
BRAND_ICON=/usr/share/nubo/logo/nubo-account.png

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root." >&2
  exit 1
fi

echo "==> Checking Nubo SSO"
discovery="$(curl -fsS -m 15 "${ISSUER}/.well-known/openid-configuration")"
if ! grep -q '"device_authorization_endpoint"' <<<"${discovery}"; then
  echo "${ISSUER} does not offer device sign-in; cannot continue." >&2
  exit 1
fi

echo "==> Installing sign-in service"
export DEBIAN_FRONTEND=noninteractive
apt-get install -y authd >/dev/null </dev/null
snap list authd-oidc >/dev/null 2>&1 || snap install authd-oidc

echo "==> Pointing it at ${ISSUER}"
umask 077
cat >"${BROKER_CONF}" <<EOF
[oidc]
issuer = ${ISSUER}
client_id = ${CLIENT_ID}
# Lets the session be renewed without signing in again each time.
extra_scopes = offline_access

[users]
# The first Nubo account to sign in owns the machine and can administer it.
# Everyone else is refused until the owner allows them.
allowed_users = OWNER
owner_extra_groups = sudo,lpadmin
EOF

umask 022
if [[ -f /usr/share/nubo/logo/nubo-mark-white.svg ]] && command -v rsvg-convert >/dev/null; then
  rsvg-convert -w 128 -a /usr/share/nubo/logo/nubo-mark-white.svg -o "${BRAND_ICON}"
fi

mkdir -p /etc/authd/brokers.d
cat >/etc/authd/brokers.d/nubo.conf <<EOF
[authd]
name = Nubo Account
brand_icon = $([[ -f "${BRAND_ICON}" ]] && echo "${BRAND_ICON}" || echo /snap/authd-oidc/current/broker_icon.png)
dbus_name = com.ubuntu.authd.Oidc
dbus_object = /com/ubuntu/authd/Oidc
EOF

echo "==> Restarting services"
systemctl restart snap.authd-oidc.authd-oidc.service
systemctl restart authd.service
systemctl is-active authd.service snap.authd-oidc.authd-oidc.service

echo "==> Done. On the login screen choose 'Not listed?', enter the Nubo"
echo "    email address, then pick 'Nubo Account'."
