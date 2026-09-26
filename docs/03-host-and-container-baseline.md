# 03 — Host and container baseline

## Host requirements

Use a supported 64-bit Linux platform with synchronized time, reliable storage, current Docker Engine and Compose v2, and an operator-controlled firewall. NPMplus upstream supports `amd64v2` and `arm64`; verify CPU compatibility before change approval.

Avoid running the Docker workload inside an unprivileged or feature-constrained LXC unless the complete stack has been tested and the additional isolation boundary is deliberately accepted. A dedicated VM or host is easier to reason about and recover.

## Operating-system baseline

- Apply security updates through a documented maintenance process.
- Use SSH keys, disable direct remote root login, and restrict SSH by network policy.
- Synchronize time and monitor drift.
- Configure persistent logs or forward them to another system.
- Reserve capacity for images, logs, certificates, database growth, and backups.
- Enable a host firewall before publishing NAT rules.
- Keep `/opt/npmplus` on resilient storage with monitored free space and inodes.

## Docker daemon

Treat Docker control as root-equivalent. Limit membership of the `docker` group, protect the daemon socket, and do not expose an unauthenticated TCP API. Record daemon configuration and storage driver.

Use the upstream image source and verify the resolved digest:

~~~bash
docker image inspect docker.io/zoeyvid/npmplus:latest \
  --format '{{index .RepoDigests 0}}'
~~~

For production, deploy an explicitly reviewed tag or digest rather than allowing an unreviewed `latest` pull during restart.

## Container privileges

The upstream baseline drops all capabilities and adds only `NET_BIND_SERVICE` and `SETGID`. Add optional capabilities only for an enabled feature and record why. Keep `no-new-privileges:true`.

Do not mount:

- the Docker socket;
- the host root filesystem;
- broad application trees that the proxy does not need;
- credential directories unrelated to NPMplus.

## File permissions

Restrict the persistent data directory and backup staging area. If `PUID`/`PGID` are changed, verify ownership and every extra capability requested by the upstream Compose comments. Do not fix permission errors with world-writable modes.

## Preflight gate

Run `scripts/npmplus-host-preflight.sh` and resolve:

- unexpected public listeners;
- missing time synchronization;
- low disk or inode headroom;
- unavailable Docker/Compose;
- risky daemon exposure;
- absent firewall visibility.

