# NPMplus production acceptance record

- Deployment/change ID:
- Date:
- Environment:
- NPMplus image tag/digest:
- Approvers:

| Test | Expected result | Evidence | Pass/Fail |
|---|---|---|---|
| Public listeners | only approved ports | | |
| Admin UI | inaccessible from Internet | | |
| Unknown hostname | approved default response | | |
| Backend bypass | blocked | | |
| Real client IP | correct and spoof resistant | | |
| Admin identity | MFA/OIDC and recovery pass | | |
| TLS | valid chain, names, expiry | | |
| Access lists | allowed and denied tests pass | | |
| CrowdSec | acquisition and remediation healthy | | |
| Application profile | login, upload, WebSocket/stream as applicable | | |
| Monitoring | synthetic check and alert delivered | | |
| Backup | current successful recovery point | | |
| Restore | isolated test within required interval | | |

## Exceptions

Record risk owner, compensating control, expiry date, and remediation ticket for every exception.

## Decision

- [ ] Approved for production
- [ ] Approved with time-limited exceptions
- [ ] Rejected

Name/date/sign-off:

