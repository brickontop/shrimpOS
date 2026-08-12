# Store publisher procedure

Apps are immutable squashfs files. Build one in a clean container, calculate SHA-256, add its HTTPS URL and hash to `public/manifest.json`, then create `manifest.json.asc` with an offline publisher key. Serve both over HTTPS with immutable-cache headers. Rotate keys only by shipping a signed OS release containing the replacement public key. Never put a private key on the server.

Example manifest entry: `{"name":"hello","url":"https://store.example.invalid/apps/hello.squashfs","sha256":"REPLACE"}`. The placeholder sample exists only to illustrate layout and is not installable.
