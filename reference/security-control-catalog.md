# Security control catalog

| ID | Control | Evidence | Frequency |
|---|---|---|---|
| NPM-01 | Dedicated supported edge host | asset record, patch report | quarterly |
| NPM-02 | Management UI private | bindings, firewall, external denial test | each change |
| NPM-03 | Named admins with MFA/OIDC | access review | quarterly |
| NPM-04 | Break-glass access tested | recovery record | semi-annually |
| NPM-05 | Image tag and digest approved | change record | each upgrade |
| NPM-06 | Minimal container capabilities | inspect output | each upgrade |
| NPM-07 | Public listeners inventoried | `ss`, firewall/NAT evidence | monthly |
| NPM-08 | Real-IP trust validated | normal/direct/spoof tests | each path change |
| NPM-09 | Backends not publicly reachable | external scan/test | each onboarding |
| NPM-10 | Certificates monitored | external probe and alerts | daily |
| NPM-11 | DNS credentials least privilege | provider policy review | semi-annually |
| NPM-12 | Access lists owned and tested | inventory and denied test | quarterly |
| NPM-13 | CrowdSec acquisition healthy | `cscli metrics` | daily |
| NPM-14 | Security exceptions expire | exception register | monthly |
| NPM-15 | Logs retained and protected | logging configuration | quarterly |
| NPM-16 | Complete encrypted backup | backup report | daily/defined RPO |
| NPM-17 | Isolated restore successful | recovery-test record | quarterly |
| NPM-18 | Change rollback defined | approved change record | each change |
| NPM-19 | Unknown hosts fail safely | external test | each deployment |
| NPM-20 | Incident credentials rotatable | incident exercise | annually |

