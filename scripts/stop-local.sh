#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
docker compose down
if [ "${1:-}" = "--volumes" ] || [ "${1:-}" = "-v" ]; then
    docker volume rm mulu-caves_mulu-db-data 2>/dev/null || true
fi