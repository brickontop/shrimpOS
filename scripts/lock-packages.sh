#!/bin/sh
set -eu
out=packages.lock; : > "$out"
for pkg in $(sed -n 's/=.*//p' packages.txt); do apt-cache policy "$pkg" | awk -v p="$pkg" '/Candidate:/ {print p "=" $2}' >> "$out"; done
LC_ALL=C sort -u "$out" -o "$out"
sha256sum "$out" > packages.lock.sha256
