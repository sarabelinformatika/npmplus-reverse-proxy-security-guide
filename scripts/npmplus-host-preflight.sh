#!/usr/bin/env bash
set -u

# Read-only host readiness report. No configuration is changed.
failures=0
warnings=0

section() { printf '\n## %s\n' "$1"; }
ok() { printf '[OK] %s\n' "$1"; }
warn() { printf '[WARN] %s\n' "$1"; warnings=$((warnings + 1)); }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

section "Host"
printf 'Hostname: %s\n' "$(hostname -f 2>/dev/null || hostname)"
if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  printf 'Operating system: %s\n' "${PRETTY_NAME:-unknown}"
else
  warn "/etc/os-release is not readable"
fi
printf 'Kernel: %s\n' "$(uname -srmo 2>/dev/null || true)"

section "Time"
if command -v timedatectl >/dev/null 2>&1; then
  timezone=$(timedatectl show -p Timezone --value 2>/dev/null || true)
  synchronized=$(timedatectl show -p NTPSynchronized --value 2>/dev/null || true)
  printf 'Timezone: %s\n' "${timezone:-unknown}"
  if [[ "$synchronized" == "yes" ]]; then
    ok "System clock reports synchronized"
  else
    warn "System clock does not report NTP synchronization"
  fi
else
  warn "timedatectl is unavailable"
fi

section "Docker"
if command -v docker >/dev/null 2>&1; then
  ok "Docker CLI is available"
  docker version --format 'Client: {{.Client.Version}} Server: {{.Server.Version}}' 2>/dev/null || warn "Docker daemon is not accessible"
  if docker compose version >/dev/null 2>&1; then
    ok "Docker Compose v2 is available"
    docker compose version 2>/dev/null || true
  else
    fail "Docker Compose v2 is unavailable"
  fi
else
  fail "Docker CLI is unavailable"
fi

if [[ -S /var/run/docker.sock ]]; then
  socket_mode=$(stat -c '%a %U:%G' /var/run/docker.sock 2>/dev/null || true)
  printf 'Docker socket: %s\n' "${socket_mode:-unknown}"
fi

section "Storage"
for path in / /var/lib/docker /opt/npmplus; do
  if [[ -e "$path" ]]; then
    df -hPT "$path" 2>/dev/null | awk 'NR == 1 || NR == 2'
    df -Pi "$path" 2>/dev/null | awk 'NR == 1 || NR == 2'
  else
    warn "$path does not exist"
  fi
done

if [[ -d /opt/npmplus ]]; then
  data_mode=$(stat -c '%a %U:%G' /opt/npmplus 2>/dev/null || true)
  printf '/opt/npmplus permissions: %s\n' "${data_mode:-unknown}"
  if find /opt/npmplus -xdev -type f -perm -0002 -print -quit 2>/dev/null | grep -q .; then
    warn "World-writable files exist under /opt/npmplus"
  else
    ok "No world-writable files detected under /opt/npmplus"
  fi
fi

section "Listening sockets"
if command -v ss >/dev/null 2>&1; then
  ss -lntup 2>/dev/null || ss -lntp 2>/dev/null || true
else
  warn "ss is unavailable"
fi

section "Firewall visibility"
if command -v nft >/dev/null 2>&1; then
  if nft list ruleset >/dev/null 2>&1; then
    ok "nftables ruleset is readable"
    nft list ruleset 2>/dev/null || true
  else
    warn "nftables exists but the ruleset is not readable"
  fi
elif command -v ufw >/dev/null 2>&1; then
  ufw status verbose 2>/dev/null || warn "UFW status is not readable"
elif command -v firewall-cmd >/dev/null 2>&1; then
  firewall-cmd --state 2>/dev/null || warn "firewalld state is not readable"
else
  warn "No supported firewall inspection command found"
fi

section "Summary"
printf 'Failures: %d\nWarnings: %d\n' "$failures" "$warnings"
printf 'This report is read-only and does not prove perimeter or application security.\n'
((failures == 0))

