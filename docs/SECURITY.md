# Security review checklist

- Verify the snapshot mirror, `packages.lock`, ISO SHA-256, manifest signature, and release signature.
- Verify no enabled unit performs a write or network update without an interactive approval gate.
- Test normal and Safe Mode boot paths; Safe Mode must reject `store install`.
- Test an invalid manifest signature, an invalid package hash, and unsigned dev mode denial.
- Inspect `/var/lib/shrimp/proposals` and `/var/log/shrimp-audit.log` after every mutating test.
- Build twice in isolated, matching Ubuntu environments and compare ISO hashes; investigate any difference.
