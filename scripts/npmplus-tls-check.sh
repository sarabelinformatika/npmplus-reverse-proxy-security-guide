#!/usr/bin/env bash
set -u

# Read-only DNS, HTTP, and TLS endpoint validation.
host=${1:-}
port=${2:-443}

if [[ -z "$host" || "$host" == -* || "$port" == -* ]]; then
  printf 'Usage: %s hostname [port]\n' "$0" >&2
  exit 2
fi
if [[ ! "$port" =~ ^[0-9]+$ ]] || ((port < 1 || port > 65535)); then
  printf 'Invalid port: %s\n' "$port" >&2
  exit 2
fi

failures=0
warnings=0
section() { printf '\n## %s\n' "$1"; }
warn() { printf '[WARN] %s\n' "$1"; warnings=$((warnings + 1)); }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

section "DNS"
if command -v dig >/dev/null 2>&1; then
  printf 'A records:\n'
  dig +short A "$host" 2>/dev/null || true
  printf 'AAAA records:\n'
  dig +short AAAA "$host" 2>/dev/null || true
else
  getent ahosts "$host" 2>/dev/null || fail "Name resolution failed or no resolver tool is available"
fi

section "Certificate"
if ! command -v openssl >/dev/null 2>&1; then
  fail "openssl is unavailable"
else
  certificate=$(timeout 15 openssl s_client -connect "${host}:${port}" -servername "$host" -showcerts </dev/null 2>/dev/null | openssl x509 -noout -subject -issuer -serial -dates -ext subjectAltName 2>/dev/null || true)
  if [[ -n "$certificate" ]]; then
    printf '%s\n' "$certificate"
  else
    fail "TLS certificate could not be retrieved"
  fi

  if timeout 15 openssl s_client -connect "${host}:${port}" -servername "$host" -verify_hostname "$host" </dev/null 2>&1 | grep -q 'Verify return code: 0'; then
    printf '[OK] Certificate chain and hostname verification passed\n'
  else
    fail "Certificate chain or hostname verification failed"
  fi

  if timeout 15 openssl s_client -connect "${host}:${port}" -servername "$host" </dev/null 2>/dev/null | openssl x509 -checkend 1209600 -noout >/dev/null 2>&1; then
    printf '[OK] Certificate is valid for more than 14 days\n'
  else
    warn "Certificate expires within 14 days or expiry could not be checked"
  fi
fi

section "HTTP response"
if command -v curl >/dev/null 2>&1; then
  curl --silent --show-error --head --max-time 15 "https://${host}:${port}/" 2>&1 | sed -n '1,25p' || fail "HTTPS request failed"
else
  warn "curl is unavailable"
fi

section "Summary"
printf 'Failures: %d\nWarnings: %d\n' "$failures" "$warnings"
printf 'This report is read-only and should also be run from an external network.\n'
((failures == 0))

