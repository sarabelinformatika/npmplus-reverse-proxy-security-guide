# 13 — Logging, monitoring, and alerting

## Observability objectives

Monitoring must distinguish edge availability, certificate health, proxy correctness, backend health, security events, and capacity. A green container state alone proves none of these.

## Log sources

- NPMplus container startup and application logs.
- Nginx access and error logs when enabled.
- CrowdSec acquisition, decisions, and bouncer status.
- Host authentication, firewall, Docker, kernel, time, disk, and OOM events.
- External synthetic checks for each critical public host.
- Identity-provider and DNS-provider audit logs.

Protect logs from unauthorized access because they may contain client addresses, paths, user agents, identifiers, and operational detail. Define retention and privacy requirements before enabling expanded logging.

## GoAccess

GoAccess can provide useful operational analytics from NPMplus logs. Restrict it to authenticated administrators, anonymize addresses according to policy, and do not treat analytics as a security information and event management system.

## Minimum alerts

- container unhealthy, stopped, or restart-looping;
- unexpected listener or image digest;
- certificate renewal failure or short remaining lifetime;
- repeated Nginx configuration/reload failure;
- sustained 4xx/5xx or latency change;
- CrowdSec acquisition/bouncer failure;
- disk or inode pressure in the data and log paths;
- host time drift;
- backup failure or stale restore test;
- administrator or OIDC anomalies where audit data exists.

## External checks

Test from outside the production network:

- DNS A/AAAA correctness;
- TLS hostname, chain, and expiry;
- HTTP status and redirect path;
- expected authentication challenge;
- a known denied host/location;
- HTTP/3 when enabled.

## Evidence

Store alert ownership, thresholds, test results, and runbook links. Every production alert needs an actionable response; dashboards without owners are not controls.

