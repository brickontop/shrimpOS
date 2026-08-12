#!/bin/sh
set -eu
iso=${1:?ISO path required}; test -f "$iso"
qemu-system-x86_64 -m 2048 -accel kvm -cdrom "$iso" -serial stdio -display none -no-reboot || true
echo 'Manual VM assertions: select Safe Mode; confirm cat /proc/cmdline contains shrimp.safe=1; confirm store install fails; in normal mode confirm firefox and nmcli exist.'
