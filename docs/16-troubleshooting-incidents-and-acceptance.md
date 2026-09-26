# 16 — Troubleshooting, incidents, and acceptance

## Safe troubleshooting order

1. Preserve timestamps, versions, logs, and the most recent change record.
2. Identify whether the fault is DNS, routing, firewall, listener, TLS, Nginx generation, access policy, identity, CrowdSec, or upstream application.
3. Test one boundary at a time.
4. Avoid disabling multiple security controls simultaneously.
5. Record every temporary exception and remove it after diagnosis.

## Common symptoms

| Symptom | First checks |
|---|---|
| UI unavailable | management binding, firewall, HTTPS on port 81, container logs |
| 502/504 | upstream address/port/scheme, routing, backend health, timeout |
| redirect loop | upstream proxy awareness, forwarded scheme, application base URL |
| certificate request fails | DNS, ports, challenge type, rate limits, provider token |
| wrong client IP | proxy path, `TRUST_IP`, CDN-only enforcement, log format |
| unexpected 403 | access lists, CrowdSec/AppSec, auth_request, mTLS |
| config reload fails | recent UI/custom-Nginx change, generated config, syntax logs |
| large upload fails | body limit, request buffering, AppSec, disk, upstream timeout |
| HTTP/3 absent | 443/UDP, firewall/NAT, proxy protocol, client/network support |

## Incident containment

For suspected compromise:

- remove public NAT or isolate the host while preserving management evidence;
- capture container image digest, inspect output, logs, process/socket state, and file hashes;
- revoke or rotate admin, OIDC, DNS, CrowdSec, cookie, and certificate material as indicated;
- identify every published backend that may have been affected;
- rebuild from trusted sources rather than cleaning an unknown state;
- restore only validated data and re-run acceptance.

## Production acceptance

Do not approve production until all applicable items pass:

- public and management listeners match design;
- unknown hosts return the approved default response;
- direct backend access is blocked;
- real-client-IP trust resists spoofing;
- administrator MFA/OIDC and break-glass access work;
- certificates issue and renew through the intended path;
- allowed and denied access-list tests pass;
- CrowdSec acquisition and remediation are healthy;
- critical applications, uploads, WebSockets, gRPC, and streams pass their profiles;
- external monitoring and alerts are tested;
- backup completion and isolated restore are evidenced;
- rollback criteria and owner are documented.

Use the acceptance and recovery templates. A screenshot alone is not sufficient evidence when machine-readable output or an external test is available.

