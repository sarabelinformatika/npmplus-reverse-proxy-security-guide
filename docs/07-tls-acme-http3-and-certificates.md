# 07 — TLS, ACME, HTTP/3, and certificates

## Certificate ownership

For every certificate record domains, issuer, challenge type, key type, renewal owner, expiry alert, and revocation procedure. Wildcards increase convenience and blast radius; use them only with explicit justification.

## ACME challenges

- **HTTP-01:** operationally simple, but port 80 and correct public routing are required.
- **DNS-01:** supports wildcards and private origins, but introduces a DNS-provider credential.

Scope DNS tokens to the smallest possible zone and permission set. Do not reuse an account-wide administrative token. Confirm that backups containing the token are encrypted and access controlled.

## TLS policy

NPMplus provides hardened TLS defaults. Avoid replacing them with generic snippets copied from older Nginx tutorials. Change protocol, cipher, curve, OCSP, Must-Staple, or certificate-compression settings only with a compatibility test and rollback plan.

Use ECDSA where clients support it; retain RSA only for a documented compatibility need. Never enable insecure upstream or ACME certificate verification bypasses to silence an error.

## HTTP/3 and QUIC

HTTP/3 requires 443/UDP in addition to 443/TCP and must be supported by the network path. Validate:

- host firewall and perimeter NAT;
- no conflicting UDP listener;
- client negotiation from an external network;
- graceful fallback to HTTP/2/TCP;
- monitoring that does not declare success based only on TCP.

If proxy protocol is enabled for HTTPS listeners, review its documented interaction with HTTP/3 before deployment.

## HSTS and preload

Enable HSTS only after every required subdomain works reliably over HTTPS. `includeSubDomains` and preload can create long-lived outages when legacy or delegated names are not ready. Preload submission is an external commitment, not a checkbox to enable casually.

## Renewal monitoring

Monitor externally for:

- certificate expiry and hostname coverage;
- correct chain and key algorithm;
- unexpected issuer change;
- TLS negotiation;
- renewal failures in logs;
- DNS challenge cleanup.

Run `scripts/npmplus-tls-check.sh` from outside the edge network as well as locally.

## Private-key incident

When exposure is suspected: remove the cause, revoke or replace the certificate as supported by the issuer, rotate DNS credentials, replace affected backups if necessary, invalidate sessions where appropriate, and document the incident timeline.

