#!/usr/bin/env bash
# List everything on an installed Nubo OS system that still shows, names or
# links to Ubuntu. Run on the target system; prints a report to stdout.
# Read-only.

set -uo pipefail

section() { printf '\n== %s\n' "$*"; }

section "Identity files"
for f in /etc/os-release /etc/lsb-release /etc/issue /etc/legal /etc/update-motd.d/* /etc/default/grub /etc/default/grub.d/*; do
  [[ -f "$f" ]] || continue
  hits="$(grep -n -i 'ubuntu' "$f" 2>/dev/null | head -3)"
  [[ -n "$hits" ]] && printf '%s\n%s\n' "$f" "$hits"
done

section "Boot menu titles"
sudo grep -h -E "^menuentry|^submenu" /boot/grub/grub.cfg 2>/dev/null | cut -c1-80 | head -5

section "Applications that show Ubuntu (name, comment or icon)"
grep -l -i -E '^(Name|Comment|Icon|GenericName)(\[[a-z_]+\])?=.*ubuntu' /usr/share/applications/*.desktop 2>/dev/null \
  | while read -r f; do
      printf '%-55s %s\n' "$(basename "$f")" "$(grep -m1 -E '^(Name|Icon)=' "$f" | cut -c1-60)"
    done

section "Applications whose icon is Ubuntu artwork"
for f in /usr/share/applications/*.desktop; do
  icon="$(sed -n 's/^Icon=//p' "$f" | head -1)"
  case "$icon" in *ubuntu*|*yaru*|distributor-logo*|start-here*) printf '%-55s %s\n' "$(basename "$f")" "$icon" ;; esac
done

section "Packages carrying the Ubuntu name or brand"
dpkg-query -W -f '${Package} ${Status}\n' 2>/dev/null | awk '$4=="installed"{print $1}' \
  | grep -E 'ubuntu|yaru|snap|apport|whoopsie|popularity|update-notifier|update-manager|advantage|landscape|canonical' \
  | sort | tr '\n' ' '; echo

section "Snaps installed"
snap list 2>/dev/null | tail -n +2 | awk '{print $1" "$2}' | tr '\n' ', '; echo

section "Default settings that still say Ubuntu"
grep -rn -i 'ubuntu' /usr/share/glib-2.0/schemas/*.override 2>/dev/null | grep -v -E '^.*/(90_nubo)' | grep -v -E ':ubuntu\]' | cut -c1-140 | head -20

section "Fonts in use"
for k in font-name document-font-name monospace-font-name; do
  printf '%-22s %s\n' "$k" "$(gsettings get org.gnome.desktop.interface $k 2>/dev/null)"
done
gsettings get org.gnome.desktop.wm.preferences titlebar-font 2>/dev/null

section "Package sources"
grep -rh -E '^(URIs:|deb )' /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null | sort -u

section "Services named after Ubuntu"
systemctl list-unit-files --no-legend 2>/dev/null | awk '{print $1}' | grep -E 'ubuntu|apport|whoopsie|snap' | tr '\n' ' '; echo

section "Firefox defaults"
grep -rh -i -E 'homepage|startup' /etc/firefox/policies/policies.json /snap/firefox/current/distribution/policies.json 2>/dev/null | head -3

section "Icons named after Ubuntu in the active icon theme path"
find /usr/share/icons/hicolor /usr/share/icons/Nubo-Dark -iname '*ubuntu*' 2>/dev/null | wc -l

section "Wallpapers, sounds, cursors still installed from Ubuntu"
ls -d /usr/share/backgrounds/*ubuntu* /usr/share/backgrounds/warty* /usr/share/sounds/Yaru /usr/share/icons/Yaru* /usr/share/themes/Yaru* 2>/dev/null | tr '\n' ' '; echo

section "Strings shown in Settings › About"
grep -E '^(NAME|PRETTY_NAME|VERSION|LOGO)=' /etc/os-release
