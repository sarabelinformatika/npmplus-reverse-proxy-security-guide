# 02 — Architecture and trust boundaries

## Recommended zones

Separate at least four logical zones:

1. **Untrusted ingress** — Internet traffic reaching 80/TCP, 443/TCP, and optionally 443/UDP.
2. **Edge host** — the Docker host and NPMplus container.
3. **Application network** — approved upstream services only.
4. **Management network** — administrators, monitoring, backup, and identity services.

The edge host should not be a general application server. Every additional workload increases patching, credential, port-collision, and lateral-movement risk.

## Core traffic paths

| Path | Trust decision |
|---|---|
| Internet → NPMplus | domain, TLS, request policy, access list, AppSec |
| NPMplus → upstream | fixed destination, protocol, TLS validation where supported |
| Administrator → UI | management path, MFA/OIDC, audit logging |
| NPMplus → ACME/DNS | minimal outbound and least-privilege token |
| NPMplus ↔ CrowdSec | authenticated bouncer/decision flow |
| Backup system → data | read-only acquisition where practical; encrypted destination |

## Network mode decision

The upstream reference Compose uses host networking and minimal Linux capabilities. Host networking simplifies real-client-IP handling and is required by some documented NPMplus integrations, but removes Docker port publishing as an isolation boundary. Compensate with a host firewall, dedicated host, explicit bindings, and continuous socket inventory.

Bridge networking may be appropriate in a tested design, but do not assume behavior from vanilla Nginx Proxy Manager. Confirm HTTP/3, real-IP, CrowdSec, certificate challenge, and stream behavior before adoption.

## Management-plane isolation

Prefer `NPM_LISTEN_LOCALHOST=true` with access through a management VPN or an authenticated local tunnel. An alternative is binding the UI only to a management address using `NPM_IPV4_BINDING` and `NPM_IPV6_BINDING` plus firewall enforcement.

Do not publish port 81 through the perimeter router. Proxying the NPMplus UI through itself can be done, but creates a circular dependency and should not be the only break-glass path.

## Backend isolation

- Block direct Internet access to upstream ports.
- Allow ingress from the NPMplus host or a dedicated proxy subnet only.
- Keep administrative ports separate from proxied application ports.
- Prefer TLS to sensitive upstreams when traffic crosses a shared network.
- Validate the backend's own authentication and CSRF controls; the proxy is not a substitute.

## Failure containment

Document how to:

- disable a single host without affecting others;
- remove public NAT while retaining management access;
- restore the data tree on an isolated replacement host;
- revoke DNS, OIDC, and CrowdSec credentials;
- replace certificates after suspected key disclosure.

