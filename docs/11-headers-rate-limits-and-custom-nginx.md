# 11 — Headers, rate limits, and custom Nginx

## Secure defaults first

NPMplus already applies hardened headers and removes fingerprinting information. Inspect the effective response before adding custom directives. Duplicate or conflicting headers can reduce security or break applications.

## Header decisions

| Header/control | Decision point |
|---|---|
| HSTS | all affected names permanently ready for HTTPS |
| CSP | application-specific resources and reporting tested |
| X-Frame-Options/frame-ancestors | embedding requirement understood |
| Referrer-Policy | analytics and cross-origin workflows tested |
| Permissions-Policy | browser capabilities explicitly needed |
| noindex | intended for non-public content, not an access control |

Treat CSP as an application policy. A broad proxy-wide CSP commonly breaks services or permits more than intended.

## Rate limiting

Use rate limiting to protect expensive or abuse-prone paths, not as a substitute for capacity planning. Base limits on verified client IPs and application behavior. Define:

- key and trust source;
- steady rate and burst;
- response code;
- exempt health checks and trusted automation;
- observability and rollback.

If CrowdSec consumes Nginx rate-limit events, include the error log in acquisition as documented upstream and understand which fields are client-controlled.

## Custom Nginx

Custom directives are a last resort. Before using them:

1. confirm the function is not available in the UI or supported environment variables;
2. use current NPMplus syntax, not a vanilla NPM tutorial;
3. identify the exact generated context;
4. run configuration validation;
5. test a restart as well as a reload;
6. record removal and rollback steps.

Avoid `if`-heavy logic, unrestricted reflection of headers, permissive CORS, blanket buffering changes, and copied TLS cipher lists.

## Review gate

Changes to `TRUST_IP`, custom Nginx, TLS, redirects, authentication headers, rate-limit keys, or access-list inheritance require peer review because errors can silently weaken controls.

