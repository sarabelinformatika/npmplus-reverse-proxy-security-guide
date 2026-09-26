# 08 — Proxy hosts, locations, and access lists

## Host onboarding record

Before creating a proxy host, document:

- service owner and data classification;
- public domain and DNS change;
- upstream address, port, scheme, and health path;
- certificate and renewal method;
- intended public audience;
- authentication and access lists;
- upload limits, buffering, timeouts, WebSockets, or gRPC needs;
- security headers and application exceptions;
- rollback and retirement plan.

## Access lists

NPMplus supports multiple access lists per host and location. Use descriptive names tied to an owner and purpose. Avoid a single global list that silently accumulates unrelated networks.

IP allowlists are useful only when the real-client-IP chain is correct and the user's source address is stable. They are not a replacement for authentication. Validate access from an allowed source, a denied source, and a forged-header attempt.

## Custom locations

Location matching and path rewriting can expose more than intended. Confirm trailing-slash behavior, upstream paths, authentication inheritance, and access-list selection. Test common bypass variants, including encoded paths and alternate case where the application is case-insensitive.

## Error and default behavior

- Do not leak upstream names, software versions, or stack traces.
- Use a minimal default response for unknown hosts.
- Decide whether redirects preserve or discard paths and queries.
- Avoid open redirects based on untrusted host or forwarded headers.

## Change validation

After every host or location edit:

1. confirm Nginx configuration reload succeeds;
2. inspect the generated configuration and relevant logs;
3. test intended and denied access paths externally;
4. confirm the backend is still unreachable directly;
5. verify certificate, redirects, security headers, uploads, and application login;
6. attach evidence to the change record.

## Decommissioning

Disable traffic, remove DNS after the approved retention window, remove certificates and credentials no longer required, delete obsolete access lists, update monitoring, and preserve the change record. Do not leave a retired domain pointing to the generic edge indefinitely.

