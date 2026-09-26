# 14 — Backup and recovery

## Recovery objective

The essential asset is the complete persistent NPMplus data tree plus the deployment definition, external credentials inventory, DNS state, image reference, and recovery instructions. A directory copy that has never been restored is not a proven backup.

## Backup contents

- `/opt/npmplus` or the configured `/data` source.
- Compose and environment templates, with secrets stored through the approved protected mechanism.
- exact image tag and digest;
- host firewall and NAT documentation;
- DNS, certificate, OIDC, CrowdSec, and monitoring inventory;
- change and acceptance records.

Do not expose backups in the web root or a broadly readable NAS share.

## Consistency

Prefer an application-consistent maintenance window or a filesystem snapshot whose behavior has been tested with the embedded SQLite database. Record whether the container was stopped, paused, or live during capture.

`scripts/npmplus-backup-manifest.sh` creates read-only inventory and hashes; it does not copy data. Pair it with the organization's backup system.

## Protection

- Encrypt in transit and at rest.
- Separate backup credentials from the Docker host.
- Keep versioned and offline/immutable recovery points.
- Monitor completion, size anomalies, and retention.
- Treat certificate keys, cookies, database, and integration secrets as sensitive.

## Restore test

At least quarterly and before major changes:

1. provision an isolated replacement host;
2. restore the data and matching deployment definition;
3. start without public NAT or production DNS;
4. validate database, administrators, proxy hosts, access lists, certificates, and generated configuration;
5. use controlled host-file or test-DNS resolution;
6. record duration, gaps, and corrective actions;
7. destroy or sanitize the test environment.

## Compromise recovery

Do not blindly restore a compromised state. Identify the entry point and recovery date, rebuild the host, patch or reconfigure the cause, rotate secrets, replace affected certificates, review host definitions, invalidate sessions, and increase monitoring.

