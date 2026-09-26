# 09 — OIDC, auth_request, and mTLS

## Separate the control planes

NPMplus supports OIDC for its administrative UI and `auth_request` integrations for protected applications. These are different trust relationships. Record distinct clients, secrets, callback paths, owners, and failure behavior.

## OIDC for administration

- Register the exact HTTPS redirect domain expected by NPMplus.
- Limit identity-provider assignment to approved operators.
- Require MFA and phishing-resistant authentication where available.
- Require verified email claims unless an equivalent immutable subject mapping is deliberately implemented.
- Retain and test a break-glass path.
- Never disable TLS verification globally to accommodate a self-signed identity provider.

## auth_request for applications

NPMplus includes integrations for common providers such as Authelia, Authentik, OAuth2 Proxy, Tinyauth, VoidAuth, and Anubis. Use the supported environment variables and UI controls instead of pasting unrelated Nginx snippets.

For each protected host validate:

- unauthenticated users are redirected or denied;
- authenticated users reach only the intended application;
- identity headers cannot be supplied directly by the client;
- sign-out and session expiry work;
- the application is not reachable around the proxy;
- provider failure produces the chosen fail-closed behavior.

Do not pass broad identity claims to applications that do not need them. Strip client-provided copies of trusted headers before setting controlled values.

## mTLS

Client certificates provide strong machine or managed-user admission but require lifecycle operations:

- unique client identity where accountability matters;
- protected private-key distribution;
- short, documented validity;
- revocation or replacement procedure;
- tested behavior for expired, unknown, and missing certificates.

Do not treat a shared client certificate as individual authentication.

## Layering controls

For sensitive services, combine network restriction, mTLS or identity-aware authentication, backend authentication, and monitoring. Avoid redundant layers that share the same failure mode or lock out recovery without a tested bypass.

