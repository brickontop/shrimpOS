#!/bin/sh
set -eu
action=${1:?set or remove}; user=${2:-admin}; f=/etc/grub.d/40_custom; begin='# SHRIMPOS PASSWORD BEGIN'; end='# SHRIMPOS PASSWORD END'
tmp=$(mktemp); trap 'rm -f "$tmp"' EXIT
sed "/$begin/,/$end/d" "$f" > "$tmp"
if [ "$action" = set ]; then
  printf 'Generate PBKDF2 hash for %s:\n' "$user" >&2; hash=$(grub-mkpasswd-pbkdf2 | awk '/grub.pbkdf2/{print $NF}')
  printf '%s\nset superusers="%s"\npassword_pbkdf2 %s %s\n%s\n' "$begin" "$user" "$user" "$hash" "$end" >> "$tmp"
elif [ "$action" != remove ]; then exit 2; fi
install -m 0755 "$tmp" "$f"; update-grub
