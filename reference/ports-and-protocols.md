# Ports and protocols

| Flow | Default | Exposure | Notes |
|---|---:|---|---|
| HTTP ingress | 80/TCP | Public when HTTP-01 or redirects are used | Disable only after challenge and redirect design |
| HTTPS ingress | 443/TCP | Public | Primary application ingress |
| HTTP/3/QUIC | 443/UDP | Public only when enabled | Validate firewall, NAT, and fallback |
| Admin UI | 81/TCP over HTTPS | Management only | Prefer localhost or management binding |
| CrowdSec LAPI | commonly 8080/TCP | Local/isolated only | Topology dependent; never expose casually |
| CrowdSec AppSec | commonly 7422/TCP | Local/isolated only | Match acquisition and container networking |
| DNS | 53/UDP,TCP outbound | Required resolver path | Monitor failures and split-DNS behavior |
| ACME/updates | 443/TCP outbound | Restricted outbound | CA, registries, identity, APIs as designed |
| NTP | 123/UDP outbound | Required time source | Certificate and log integrity depend on time |
| Upstreams | service specific | Edge → application only | Restrict by host firewall or service ACL |
| SSH | 22/TCP or policy-specific | Management only | Key-based, restricted source, audited |

Defaults can be changed by environment variables or architecture. Confirm actual sockets with `ss` and external tests.

