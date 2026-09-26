# 15 — Upgrades, migration, and change control

## Release discipline

NPMplus releases frequently. Read upstream release notes and discussions, inspect changes to `compose.yaml`, and identify migrations or security fixes. Do not let production update merely because a container restarts with `pull_policy: always`.

## Upgrade workflow

1. Record current tag, digest, Compose hash, data size, and health evidence.
2. Create and verify a pre-change backup.
3. Review new environment variables, capability changes, database migrations, access-list behavior, authentication, and certificate changes.
4. Test with a copy of production data in isolation.
5. Approve the maintenance window and rollback trigger.
6. Pull the reviewed image and record its digest.
7. Upgrade, inspect logs, and run the acceptance suite.
8. Retain the rollback image and backup until the observation period ends.

## Migration from vanilla Nginx Proxy Manager

The upstream project warns that migration back is not automatic. Before migration:

- preserve independent copies of both data and certificate directories;
- review all compatibility differences;
- map volumes exactly;
- confirm the admin interface changes from HTTP to HTTPS;
- remove the temporary legacy certificate mount only after successful migration;
- inspect every host because forms and generated configuration differ;
- test custom snippets separately;
- define rollback by restoring the original stack and untouched data.

Never run both products against the same writable database or certificate tree.

## Change classes

High-risk changes include client-IP trust, public listeners, access lists, OIDC, `auth_request`, certificate providers, custom Nginx, CrowdSec enforcement, and database migration. Require peer review and external validation.

## Configuration drift

Regularly compare the running image digest, Compose rendering, listeners, capabilities, mounts, and inventory with the approved record. The UI database is stateful; export a human-readable host inventory for review even when the database itself is backed up.

