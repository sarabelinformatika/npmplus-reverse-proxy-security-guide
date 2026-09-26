#!/usr/bin/env bash
set -u

# Read-only data inventory. It prints a manifest to stdout and does not create a
# backup. Redirect output to a protected evidence file if required.
data_dir=${1:-/opt/npmplus}

if [[ "$data_dir" != /* ]]; then
  printf 'Use an absolute data-directory path.\n' >&2
  exit 2
fi
if [[ ! -d "$data_dir" ]]; then
  printf 'Directory not found: %s\n' "$data_dir" >&2
  exit 1
fi

printf '# NPMplus backup source manifest\n'
printf 'Generated-UTC: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
printf 'Host: %s\n' "$(hostname -f 2>/dev/null || hostname)"
printf 'Source: %s\n' "$data_dir"
printf 'Filesystem:\n'
df -hPT "$data_dir" 2>/dev/null || true
printf 'Total-bytes: '
du -sb "$data_dir" 2>/dev/null | awk '{print $1}'
printf 'File-count: '
find "$data_dir" -xdev -type f -printf . 2>/dev/null | wc -c
printf '\n## Top-level inventory\n'
find "$data_dir" -mindepth 1 -maxdepth 2 -printf '%y\t%M\t%u:%g\t%s\t%p\n' 2>/dev/null | sort
printf '\n## SHA-256 file manifest\n'
find "$data_dir" -xdev -type f -print0 2>/dev/null | sort -z | xargs -0 -r sha256sum
printf '\nThis manifest contains paths and hashes but no file contents. Review paths before sharing.\n'

