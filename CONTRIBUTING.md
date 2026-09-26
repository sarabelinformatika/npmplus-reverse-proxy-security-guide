# Contributing

Contributions that improve technical accuracy, safety, portability, observability, and recovery readiness are welcome.

## Expectations

1. Open an issue before changing architecture, threat assumptions, or repository scope.
2. Use synthetic domains, IP addresses, credentials, certificates, and logs.
3. Keep scripts read-only unless a state-changing tool is explicitly approved as a separate project.
4. Link primary upstream documentation and identify the checked date or release.
5. State prerequisites, risk, validation, rollback, and evidence requirements.
6. Do not copy configuration from vanilla Nginx Proxy Manager without verifying NPMplus behavior.
7. Run ShellCheck, shell syntax checks, YAML parsing, and Markdown checks before submitting.

Never commit `.env` files, API tokens, DNS credentials, CrowdSec keys, OIDC secrets, TLS private keys, database files, production hostnames, public IP allocations, or customer data.

## Documentation style

- Write clear technical English.
- Distinguish requirements from recommendations and optional enhancements.
- Prefer `proxy.example.com`, `app.example.com`, `192.0.2.0/24`, `198.51.100.0/24`, and `203.0.113.0/24`.
- Explain trust boundaries instead of presenting unexplained snippets.
- Treat changes to client-IP trust, authentication, certificates, and custom Nginx as security-sensitive.

