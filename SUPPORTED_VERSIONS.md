# Supported versions

| Repository version | Guide status | Upstream expectation |
|---|---|---|
| 1.x | Supported | Current stable NPMplus release; verify all release-specific behavior |
| Earlier drafts | Unsupported | Historical reference only |

NPMplus uses date-based, frequently updated releases. This guide therefore avoids claiming that an unpinned `latest` image is a stable interface. Production operators should:

1. record the exact image tag and digest;
2. archive the matching upstream `README.md`, `compose.yaml`, and release notes;
3. test upgrades with a copy of production data;
4. keep a restore-tested pre-upgrade backup;
5. validate generated configuration, authentication, certificates, access lists, and application behavior after every upgrade.

Examples were reviewed against upstream documentation available on 2026-09-26. Later releases may add, rename, or remove settings.

