#!/usr/bin/env bash
set -euo pipefail

: "${DATABASE_URL:?DATABASE_URL is required}"

backup_dir="${BACKUP_DIR:-./backups}"
timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
backup_file="${backup_dir}/hisab-${timestamp}.dump"

mkdir -p "$backup_dir"
pg_dump --format=custom --no-owner --no-privileges "$DATABASE_URL" > "$backup_file"
sha256sum "$backup_file" > "${backup_file}.sha256"
printf 'Backup created: %s\n' "$backup_file"
