#!/bin/sh
# Nubo Search: Vicinae with Nubo settings. The launcher libraries ship inside
# the package, so they are put on the library path for this process only.
ROOT=/usr/lib/nubo/search
CONF="${XDG_CONFIG_HOME:-$HOME/.config}/vicinae"
SETTINGS="$CONF/settings.json"

# First run, or the untouched default file: point it at the Nubo settings.
if [ ! -f "$SETTINGS" ] || ! grep -q '"imports"' "$SETTINGS"; then
  mkdir -p "$CONF"
  cat > "$SETTINGS" <<'EOF'
{
  "$schema": "https://vicinae.com/schemas/config.json",
  "imports": ["/usr/share/nubo/search/nubo.json"]
}
EOF
fi

export LD_LIBRARY_PATH="$ROOT/usr/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
exec "$ROOT/usr/bin/vicinae" "$@"
