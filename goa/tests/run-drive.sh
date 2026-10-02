#!/bin/bash
# usage: run-drive.sh EMAIL PASSWORD [expect-fail]   (private session bus, private config/keyring)
export XDG_CONFIG_HOME=/tmp/goatest/cfg XDG_DATA_HOME=/tmp/goatest/data XDG_CACHE_HOME=/tmp/goatest/cache
export GDK_BACKEND=broadway BROADWAY_DISPLAY=:9
export NUBO_GOA_HOST=${NUBO_GOA_HOST-127.0.0.2} NUBO_GOA_ACCEPT_SSL_ERRORS=1
[ -z "$NUBO_GOA_HOST" ] && unset NUBO_GOA_HOST NUBO_GOA_ACCEPT_SSL_ERRORS
export G_MESSAGES_DEBUG=${G_MESSAGES_DEBUG-}
rm -rf /tmp/goatest/cfg /tmp/goatest/data /tmp/goatest/cache; mkdir -p /tmp/goatest/{cfg,data,cache}
exec dbus-run-session -- bash -c '
  eval "$(echo -n testpw | gnome-keyring-daemon --daemonize --unlock --components=secrets)"
  export GNOME_KEYRING_CONTROL
  gtk4-broadwayd :9 >/tmp/goatest/broadway.log 2>&1 &
  BW=$!
  sleep 1
  timeout 60 /home/ninad/nubo-goa/drive "$@"
  rc=$?
  echo "--- accounts.conf (password lines would not be here) ---"
  cat /tmp/goatest/cfg/goa-1.0/accounts.conf 2>&1
  kill $BW; pkill -u $USER -f "^/usr/libexec/goa-daemon" ; pkill -u $USER gnome-keyring-d
  exit $rc
' bash "$@"
