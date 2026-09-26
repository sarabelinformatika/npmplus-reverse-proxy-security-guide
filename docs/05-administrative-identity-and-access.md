# 05 — Administrative identity and access

## Control objective

An attacker who reaches the NPMplus UI and obtains an administrator session can redirect traffic, alter certificates, expose services, or weaken access policies. Administrative identity is therefore a privileged-access system.

## Local accounts

- Use unique named accounts; avoid shared administration.
- Require long, unique passwords stored in an enterprise password manager.
- Enable MFA for every interactive administrator.
- Protect backup codes separately from the primary factor.
- Remove unused administrators promptly.
- Test the supported password/MFA recovery procedure before an incident.

NPMplus documents a container-side password reset for SQLite deployments. Treat console access as privileged and log every use. Never expose a recovery endpoint over the network.

## OIDC

OIDC can centralize lifecycle, MFA, and conditional access. Before enabling it:

1. Use a dedicated client registration and exact redirect URI.
2. Store the client secret outside Git.
3. Require a verified email claim unless the identity design explicitly provides an equivalent assurance.
4. Restrict assignment to an administrator group at the identity provider.
5. Decide whether NPMplus local MFA is retained or skipped only after proving upstream MFA.
6. Keep a documented break-glass account and management path.

Do not set `NODE_TLS_REJECT_UNAUTHORIZED=0` as a convenience. It disables certificate verification for multiple backend operations, not only OIDC.

## Session protection

Set a strong static `COOKIE_SECRET` through protected configuration if persistent sessions are required. After suspected compromise, rotate it and understand that active sessions may be invalidated.

## Access review

Quarterly and after personnel changes, record:

- all administrators and their business owner;
- MFA/OIDC status;
- last successful login where available;
- recovery ownership;
- inactive or emergency accounts;
- management-network rules.

## Break-glass test

From the management network, prove that an authorized operator can regain access when the identity provider is unavailable. The exercise must not disable MFA in production merely to prove recovery.

