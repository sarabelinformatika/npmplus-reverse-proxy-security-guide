# Security policy

## Supported versions

Security corrections to this guide are applied to the latest release on the `main` branch. Older examples may no longer match current NPMplus behavior.

## Reporting a vulnerability

Do not open a public issue when a finding could expose credentials, bypass access controls, enable remote code execution, disclose backend addresses, or reveal a live deployment. Contact SARABEL Informatika privately through the security contact published at [sarabelinformatika.hu/.well-known/security.txt](https://sarabelinformatika.hu/.well-known/security.txt).

Include:

- affected file, release, and section;
- a minimal reproduction using synthetic data;
- prerequisites and impact;
- proposed mitigation, if known.

Do not include real domains unless necessary, and never include secrets, tokens, cookies, private keys, customer information, or full production logs.

## Scope

This repository contains documentation, examples, and read-only diagnostics. Vulnerabilities in NPMplus or another upstream component must also be reported through that project's security process. A deployment-specific misconfiguration is operationally important but is not necessarily a vulnerability in this repository.

## Response target

SARABEL Informatika aims to acknowledge valid private reports within five business days, assess severity, coordinate corrections, and credit reporters when requested.

