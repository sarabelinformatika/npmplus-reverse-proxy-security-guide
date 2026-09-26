# Architecture decision register

## ADR-001 — Dedicated edge host or VM

**Decision:** Run NPMplus on a dedicated, supported Linux host or VM.

**Reason:** Reduces port conflicts, limits co-resident workload risk, and makes backup, patching, and recovery ownership explicit.

## ADR-002 — Management plane is private

**Decision:** Bind the admin UI to localhost or a management-only address and require VPN/tunnel access.

**Reason:** The UI controls routes, certificates, and security policy and should not be an Internet login target.

## ADR-003 — Host networking is explicit

**Decision:** Use the upstream host-network baseline where required, with a host firewall and socket monitoring.

**Reason:** Matches upstream-supported real-IP and integration behavior, while acknowledging reduced Docker network isolation.

## ADR-004 — Pin reviewed production images

**Decision:** Record a tested image tag and digest; do not make restart equal upgrade.

**Reason:** NPMplus changes frequently and may include database, UI, access-list, or configuration-generation changes.

## ADR-005 — Complete data-tree backup

**Decision:** Back up the entire persistent data tree and deployment metadata, then test isolated restoration.

**Reason:** Selective certificate or database copies do not capture the complete recoverable state.

## ADR-006 — Supported controls before custom snippets

**Decision:** Prefer NPMplus UI and environment features over custom Nginx.

**Reason:** Generated contexts and hardened defaults differ from vanilla Nginx Proxy Manager tutorials.

