# 01 — Scope and threat model

## Purpose

This guide treats NPMplus as a security gateway between untrusted networks and internal services. It covers the full operating lifecycle: design, deployment, validation, change, recovery, and retirement.

It does not assume that TLS alone makes a service safe. The reverse proxy terminates or relays privileged traffic, holds certificate material, sees authentication cookies, and can make internal services reachable. Compromise therefore has a wide blast radius.

## Assets to protect

- NPMplus administrator accounts, sessions, MFA seeds, and recovery codes.
- The persistent `/data` tree, including database, generated configuration, certificates, keys, logs, and integration settings.
- DNS-provider tokens used by ACME DNS challenges.
- OIDC client secrets and `auth_request` trust relationships.
- CrowdSec bouncer credentials and decision channels.
- Backend identities, addresses, ports, cookies, headers, and application data.
- Availability and integrity of every service published through the proxy.

## Adversaries and failure modes

| Threat | Example | Primary controls |
|---|---|---|
| Internet scanning | automated discovery of exposed UI or vulnerable backend | firewall, admin isolation, default host, patching |
| Credential attack | password spraying or stolen session | MFA/OIDC, rate limits, short sessions, alerting |
| Header spoofing | forged `X-Forwarded-For` bypasses policy | explicit trusted proxies, network enforcement |
| Certificate compromise | leaked DNS token or private key | scoped credentials, protected storage, rotation |
| Backend escape | public access bypasses NPMplus | backend firewall, private networks, host validation |
| Supply-chain compromise | unsafe image or unreviewed update | pinned digest, release review, staged upgrade |
| Operator error | wrong access list exposes a host | peer review, inventory, post-change external test |
| Data loss | damaged database or incomplete backup | versioned backups, integrity checks, restore tests |

## Security objectives

1. Only intended public listeners are reachable from the Internet.
2. Management access is separated from application ingress.
3. Every published domain maps to an approved owner, upstream, certificate, and access policy.
4. Client-IP information is accepted only from verified intermediaries.
5. Administrative and machine credentials are protected and recoverable.
6. Security events can be detected, explained, and retained.
7. A failed change or compromised host can be rolled back or rebuilt.

## Scope record

For each deployment record:

- public IPs and DNS zones;
- domains, redirects, streams, and custom locations;
- management networks and operators;
- upstream services and data classification;
- certificate method and credential owner;
- CrowdSec/OIDC/auth_request integrations;
- RTO, RPO, log retention, and recovery owner;
- accepted risks and expiry dates.

Use the deployment workbook before choosing configuration values. Unknown ownership or an undefined rollback path is a deployment blocker.

