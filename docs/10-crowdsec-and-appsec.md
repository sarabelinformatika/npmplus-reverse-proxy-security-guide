# 10 — CrowdSec and AppSec

## Purpose and limits

CrowdSec can parse NPMplus logs, make behavioral decisions, and apply AppSec inspection. It reduces exposure to known hostile behavior but is not a substitute for patching, authentication, least privilege, or application security.

## Deployment outline

1. Enable NPMplus access logging with `LOGROTATE=true`.
2. Deploy CrowdSec with the `ZoeyVid/npmplus` collection.
3. Mount NPMplus logs read-only into the CrowdSec container.
4. Configure the file acquisition and AppSec listener using the provided example.
5. Create a dedicated bouncer key and place it in the protected NPMplus CrowdSec configuration.
6. Enable the integration and redeploy.
7. Confirm log acquisition, AppSec connectivity, decisions, and remediation.

Never publish the Local API or AppSec listener broadly. Bind to localhost or an isolated container/network path appropriate to the design.

## Real-IP dependency

CrowdSec decisions are only as accurate as the client identity received by NPMplus. Validate trusted proxies first. A forged or collapsed client address can cause missed attacks or block every user behind a proxy.

## AppSec behavior

Request buffering may remain enabled when AppSec is active. Test large uploads, streaming endpoints, APIs, WebSockets, and long-running requests. When an exception is required, scope it to a host or location, document the owner and expiry, and retain compensating controls.

## Collections and false positives

Add optional collections only for an observed requirement. OWASP CRS, bot detection, and DoS detection can affect legitimate clients. Stage each change, monitor alerts before enforcing when possible, and never build a whitelist solely from an untrusted domain value in a log line.

## Privacy

CrowdSec sharing or console enrollment may transmit signal metadata. Review the current CrowdSec documentation and reflect actual processing in the organization's privacy documentation.

## Validation

- `cscli metrics` shows the acquisition source.
- The bouncer is registered and pulling decisions.
- A controlled test decision blocks the test source only.
- Whitelists are narrow, owned, and reviewed.
- Disabling AppSec for one host behaves as documented and does not disable other protections.
- Logs and decisions use the verified real client IP.

Prefer blocking at the earliest reliable layer, such as a firewall bouncer, only after Docker and host-firewall behavior has been validated.

