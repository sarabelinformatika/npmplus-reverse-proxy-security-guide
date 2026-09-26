# Limitations

- This guide is independent and cannot define upstream support policy.
- NPMplus changes frequently; examples may require adjustment after release changes.
- The scripts report observable state but do not prove that an Internet perimeter, CDN, router, or backend ACL is correct.
- A successful TLS test does not prove secure application authentication or authorization.
- CrowdSec and AppSec can reduce risk but cannot guarantee detection or prevent application-specific flaws.
- GoAccess is operational analytics, not a complete SIEM or compliance archive.
- Backup manifests prove file inventory and hashes, not application-consistent recoverability.
- IP allowlists depend on correct real-client-IP trust and stable source addressing.
- Security headers require application-specific testing.
- HTTP/3 behavior depends on clients and intermediate networks outside NPMplus.
- No example should be applied unchanged without documenting the target architecture and rollback path.

