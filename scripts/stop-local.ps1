# ==========================================================
# Stop and clean local development environment
# ==========================================================
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
docker compose down
if ($args -contains '--volumes' -or $args -contains '-v') {
    docker volume rm mulu-caves_mulu-db-data 2>$null
}