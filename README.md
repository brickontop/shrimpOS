# ShrimpOS

ShrimpOS is an Ubuntu 24.04 LTS live/installable ISO scaffold. Ubuntu LTS supplies a supported, well-documented base with stable security maintenance; this project uses `live-build` and a dated Ubuntu snapshot to make its inputs inspectable and repeatable. It intentionally contains no AI daemon or autonomous configuration agent.

## Build

Run on Ubuntu 24.04 (native or an Ubuntu VM), not Windows:

```sh
sudo apt-get update
sudo apt-get install -y live-build debootstrap squashfs-tools xorriso gnupg qemu-system-x86
git clone <YOUR-REPOSITORY-URL> ShrimpOS && cd ShrimpOS
export SOURCE_DATE_EPOCH=1714521600
./scripts/lock-packages.sh
sudo lb build 2>&1 | tee build.log
mv live-image-amd64.hybrid.iso ShrimpOS.iso
sha256sum ShrimpOS.iso | tee ShrimpOS.iso.sha256
./scripts/generate-manifest.sh
```

`packages.lock` is an input after its first capture. Review its diff before rebuilding. The default snapshot is 2024-05-01; update both the snapshot date and `SOURCE_DATE_EPOCH` together only through a reviewed release change.

## Store

`store install NAME` downloads `manifest.json` and `manifest.json.asc`, verifies the manifest against `/etc/shrimp/store.gpg`, then verifies the app hash. It prints a proposed file list and requires the literal approval `INSTALL NAME` before applying. The launcher is executed with bubblewrap, an empty home directory, no network, and a read-only app tree. Dev mode requires both `--dev-mode` and the literal `I ACCEPT UNSIGNED CODE`.

To create a test signing key: `gpg --quick-generate-key 'ShrimpOS Store <store@example.invalid>' default default never`; export its public key to `config/includes.chroot/etc/shrimp/store.gpg`; sign the manifest detached with `gpg --armor --detach-sign manifest.json`.

## GRUB password and recovery

On an installed system run `sudo shrimp-grub-password set admin`; it asks `grub-mkpasswd-pbkdf2` for a hash and writes `/etc/grub.d/40_custom`, then runs `update-grub`. Rotate with `set` again or remove with `sudo shrimp-grub-password remove`. Keep a tested rescue USB before setting a password: loss of the password requires booting recovery media, mounting the installed root, removing the managed block in `40_custom`, and running `update-grub` in a chroot.

The **ShrimpOS Safe Mode** menu entry adds `shrimp.safe=1`; it disables store update actions and is intended for recovery from the read-only live image. `shrimp-rollback` restores only a locally-present, signed squashfs snapshot after a displayed diff and explicit approval.

## Tests

Run `./tests/run.sh ShrimpOS.iso`. Network and installer testing require a disposable VM and credentials supplied via environment variables; they never target a host system.

## Audit

State-changing helpers write a unified diff under `/var/lib/shrimp/proposals`, a JSON record with UTC timestamp/author/reason/SHA-256, and an append-only-style audit entry in `/var/log/shrimp-audit.log`. Review these artifacts before granting approval. Test automation must set `SHRIMP_TEST_SANDBOX=1`; production paths never auto-apply.
