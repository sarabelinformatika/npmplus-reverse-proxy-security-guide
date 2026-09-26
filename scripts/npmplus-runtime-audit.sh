#!/usr/bin/env bash
set -u

# Read-only Docker/NPMplus runtime report. Output may contain operational
# metadata; review before sharing.
container=${1:-npmplus}
failures=0
warnings=0

section() { printf '\n## %s\n' "$1"; }
ok() { printf '[OK] %s\n' "$1"; }
warn() { printf '[WARN] %s\n' "$1"; warnings=$((warnings + 1)); }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

if ! command -v docker >/dev/null 2>&1; then
  printf '[FAIL] Docker CLI is unavailable\n' >&2
  exit 1
fi

if ! docker inspect "$container" >/dev/null 2>&1; then
  printf '[FAIL] Container not found or inaccessible: %s\n' "$container" >&2
  exit 1
fi

section "Identity and state"
docker inspect "$container" --format 'Name={{.Name}} Image={{.Config.Image}} ID={{.Image}} Status={{.State.Status}} Started={{.State.StartedAt}} Restarts={{.RestartCount}}'
state=$(docker inspect "$container" --format '{{.State.Status}}')
if [[ "$state" == "running" ]]; then
  ok "Container is running"
else
  fail "Container state is $state"
fi

section "Security settings"
docker inspect "$container" --format 'Privileged={{.HostConfig.Privileged}} ReadonlyRootfs={{.HostConfig.ReadonlyRootfs}} NetworkMode={{.HostConfig.NetworkMode}}'
docker inspect "$container" --format 'CapDrop={{json .HostConfig.CapDrop}} CapAdd={{json .HostConfig.CapAdd}} SecurityOpt={{json .HostConfig.SecurityOpt}}'
privileged=$(docker inspect "$container" --format '{{.HostConfig.Privileged}}')
if [[ "$privileged" == "false" ]]; then
  ok "Privileged mode is disabled"
else
  fail "Privileged mode is enabled"
fi

security_opt=$(docker inspect "$container" --format '{{json .HostConfig.SecurityOpt}}')
if [[ "$security_opt" == *"no-new-privileges:true"* ]]; then
  ok "no-new-privileges is enabled"
else
  warn "no-new-privileges was not detected"
fi

section "Mounts"
docker inspect "$container" --format '{{range .Mounts}}{{printf "%s -> %s rw=%v type=%s\\n" .Source .Destination .RW .Type}}{{end}}'
if docker inspect "$container" --format '{{range .Mounts}}{{.Source}} {{end}}' | grep -q '/var/run/docker.sock'; then
  fail "Docker socket is mounted into NPMplus"
else
  ok "Docker socket is not mounted"
fi

section "Published ports and host sockets"
docker port "$container" 2>/dev/null || true
if command -v ss >/dev/null 2>&1; then
  ss -lntup 2>/dev/null | awk 'NR == 1 || /:(80|81|443)[[:space:]]/' || true
else
  warn "ss is unavailable"
fi

section "Health and recent logs"
health=$(docker inspect "$container" --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}not-configured{{end}}')
printf 'Health: %s\n' "$health"
[[ "$health" == "unhealthy" ]] && fail "Container health is unhealthy"
docker logs --since 30m --tail 200 "$container" 2>&1 | grep -Ei 'error|emerg|fatal|failed|warn' || true

section "Image digest"
image_ref=$(docker inspect "$container" --format '{{.Config.Image}}')
docker image inspect "$image_ref" --format '{{json .RepoDigests}}' 2>/dev/null || warn "Image digest is unavailable"

section "Summary"
printf 'Failures: %d\nWarnings: %d\n' "$failures" "$warnings"
printf 'This report is read-only. Redact operational metadata before sharing.\n'
((failures == 0))
