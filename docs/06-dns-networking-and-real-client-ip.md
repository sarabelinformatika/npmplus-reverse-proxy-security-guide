# 06 — DNS, networking, and real client IP

## DNS inventory

Every public record must have an owner, purpose, target, certificate method, and retirement date. Remove stale records because they continue to attract traffic and can create takeover opportunities.

Before cutover:

- validate A and AAAA records independently;
- lower TTL only for a planned window;
- confirm NAT for 80/TCP, 443/TCP, and optional 443/UDP;
- prove there is no unintended direct path to the backend;
- document split-DNS or hairpin-NAT behavior.

## IPv6

Do not publish AAAA records unless the host firewall, Docker behavior, upstream routing, monitoring, and incident response are ready for IPv6. An IPv4-only firewall does not protect an IPv6 listener.

## Real client IP

Client-IP trust is a security decision. NPMplus can trust explicitly configured proxies through `TRUST_IP` and can fetch Cloudflare networks when `TRUST_CLOUDFLARE=true`. Enable these only when traffic is forced through those intermediaries.

Never trust a broad private range or CDN header merely because it makes logs look correct. If clients can also connect directly, they may forge forwarded headers and bypass IP-based access policies or poison logs.

Validation sequence:

1. Send a request through the intended proxy/CDN.
2. Confirm NPMplus records the true client address.
3. Attempt a direct request to the origin and confirm it is blocked.
4. Inject a fake forwarded header through an untrusted path and confirm it is ignored.
5. Confirm CrowdSec and rate-limit decisions use the same effective address.

## Default host

Unknown hostnames and direct-IP requests should receive a minimal non-informative response such as 404 or 444. Do not expose a product page or management interface as the default site.

## Firewall model

Maintain rules for:

- public ingress to the NPMplus listeners;
- management access to SSH and the UI;
- NPMplus egress for DNS, ACME, upstreams, time, and required integrations;
- NPMplus-to-backend flows;
- backup and monitoring paths.

Validate rules from outside and inside; a local socket listing cannot prove perimeter behavior.

