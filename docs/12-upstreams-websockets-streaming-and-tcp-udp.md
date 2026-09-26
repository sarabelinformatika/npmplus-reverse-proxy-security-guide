# 12 — Upstreams, WebSockets, streaming, and TCP/UDP

## Upstream identity

Use stable internal DNS or documented addresses. Avoid forwarding to an unvalidated user-controlled hostname. Record whether NPMplus resolves the name dynamically or only during reload.

For sensitive traffic crossing a shared network, use TLS upstream and validate certificates where the supported feature path permits it. Never enable TLS-to-upstream controls in a way that accidentally downgrades or disables verification.

## WebSockets and gRPC

NPMplus supports WebSockets without the legacy UI toggle and includes gRPC modes. Validate connection establishment, idle duration, reconnect behavior, authentication expiry, and log visibility. Do not add obsolete upgrade-header snippets unless an application-specific test proves they are required.

## Uploads and streaming

Buffering protects upstreams and enables inspection but can increase disk use and latency. Disable request or response buffering only for a documented service requirement.

Before changing buffering, test:

- CrowdSec/AppSec interaction;
- maximum upload size and temporary storage;
- client cancellation;
- backend timeouts;
- memory and disk pressure;
- malware-scanning or DLP controls.

## Load balancing

NPMplus documents custom upstream blocks with a required `cu_` prefix. When used, define health assumptions, failover behavior, session persistence, DNS resolution, capacity, and rollback. Nginx passive failure behavior is not a full service-mesh health system.

## TCP/UDP streams

Streams expose non-HTTP protocols and do not inherit HTTP controls. For each stream record:

- public protocol and port;
- destination and encryption state;
- source restrictions;
- proxy-protocol expectations;
- application authentication;
- health and audit method.

Do not assume HTTP headers, access lists, HSTS, CSP, or AppSec protect a raw TCP/UDP stream.

## File and PHP serving

Prefer a dedicated application or PHP-FPM container. The NPMplus built-in PHP option expands the edge workload and is not the recommended production design. If file serving is enabled, prevent directory traversal, unintended indexes, script execution in upload locations, and broad host mounts.

