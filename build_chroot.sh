#!/bin/sh
# Optional auditable chroot assembly; live-build is the supported ISO entry point.
set -eu
root=${1:-chroot}; suite=noble; mirror=http://snapshot.ubuntu.com/ubuntu/20240501T000000Z/
test "$(id -u)" = 0 || { echo 'Run as root' >&2; exit 1; }
debootstrap --variant=minbase --arch=amd64 "$suite" "$root" "$mirror"
install -Dm644 config/includes.chroot/etc/apt/sources.list.d/shrimp.list "$root/etc/apt/sources.list.d/shrimp.list"
cp packages.txt "$root/root/packages.txt"
chroot "$root" /bin/sh -ec 'apt-get update; sed "s/=.*//" /root/packages.txt | xargs apt-get install -y --no-install-recommends; useradd -m -s /bin/bash -G sudo shrimp'
cp -a config/includes.chroot/. "$root/"
chroot "$root" /bin/sh -ec 'chmod 0440 /etc/sudoers.d/shrimp; chmod 0755 /usr/local/bin/* /usr/local/lib/shrimp/grub-password.sh'
