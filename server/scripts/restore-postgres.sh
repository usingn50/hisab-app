#!/usr/bin/env bash
set -euo pipefail

: "${DATABASE_URL:?DATABASE_URL is required}"

backup_file="${1:?Usage: restore-postgres.sh <backup.dump> --confirm}"
confirmation="${2:-}"

if [[ "$confirmation" != "--confirm" ]]; then
  printf '%s\n' 'Refusing restore without --confirm.' >&2
  exit 2
fi

if [[ ! -f "$backup_file" || ! -f "${backup_file}.sha256" ]]; then
  printf '%s\n' 'Backup file and its .sha256 sidecar are required.' >&2
  exit 2
fi

sha256sum --check "${backup_file}.sha256"
pg_restore --clean --if-exists --no-owner --no-privileges --dbname="$DATABASE_URL" "$backup_file"
printf 'Restore completed: %s\n' "$backup_file"
