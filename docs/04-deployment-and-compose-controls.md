# 04 — Deployment and Compose controls

## Source of truth

Start from the current upstream `compose.yaml`, then maintain a reviewed local copy in version control without secrets. This repository's example demonstrates control intent but may not include every new upstream variable.

Record:

- image tag and digest;
- Compose file hash;
- `.env` ownership and permissions;
- persistent volume path;
- enabled capabilities and modules;
- listener bindings;
- backup ID and rollback owner.

## Safe initialization

1. Create the persistent directory with restrictive permissions.
2. Create `.env` outside public repositories.
3. Pull the approved image and record its digest.
4. Run `docker compose config` and review the rendered output for accidental secret disclosure before storing it as evidence.
5. Start the stack on a non-public test path.
6. Confirm the UI is HTTPS and reachable only from management.
7. Create the first administrator interactively or inject the initial values through a protected secret workflow, then remove bootstrap credentials from Compose.

## Secret handling

Values such as `INITIAL_ADMIN_PASSWORD`, `OIDC_CLIENT_SECRET`, DNS API tokens, `COOKIE_SECRET`, and CrowdSec bouncer keys must not appear in Git history, support bundles, screenshots, or shell history.

When Compose lacks a native secret interface for a setting, protect the environment file with `0600`, restrict backup access, and prefer a host-level secret provisioning process.

## Bindings

- Public: 80/TCP and 443/TCP; 443/UDP only when HTTP/3 is intended.
- Management: port 81 over HTTPS, bound to localhost or a management address.
- CrowdSec AppSec: bind auxiliary ports to localhost where the topology permits.
- Backend: no new host listener should appear merely to make an upstream reachable.

## Deployment validation

After `docker compose up -d` verify:

~~~bash
docker compose ps
docker compose logs --tail=200 npmplus
docker inspect npmplus --format '{{json .HostConfig.CapDrop}} {{json .HostConfig.CapAdd}}'
ss -lntup
~~~

Inspect logs for migration errors, certificate failures, bind conflicts, database issues, and generated Nginx configuration errors. Do not proceed while the container is restart-looping or while the UI is exposed unexpectedly.

