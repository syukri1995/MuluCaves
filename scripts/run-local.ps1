# ==========================================================
# Local development — PowerShell
# ==========================================================
# Prereqs: Docker (with Compose v2), JDK 25, Maven
#
# What it does:
#   1. Copy db.properties.template -> db.properties (idempotent)
#   2. Build the WAR with Maven
#   3. Bring up MySQL + Tomcat via docker compose
#   4. Wait for the app to respond at http://localhost:8080/mulu-caves/home
# ==========================================================

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

# 1) Materialise db.properties
if (-not (Test-Path "src\main\webapp\WEB-INF\db.properties")) {
    Write-Host "==> Creating db.properties from template..."
    Copy-Item "src\main\webapp\WEB-INF\db.properties.template" `
              "src\main\webapp\WEB-INF\db.properties"
    (Get-Content "src\main\webapp\WEB-INF\db.properties") `
        -replace 'changeme','rootpw' | Set-Content "src\main\webapp\WEB-INF\db.properties"
}

# 2) Build
Write-Host "==> Checking for Maven..."
$mvnCmd = "mvn"

# Check if global mvn is available
if (-not (Get-Command "mvn" -ErrorAction SilentlyContinue)) {
    $mavenLocalDir = Join-Path $root ".maven"
    $mvnCmd = Join-Path $mavenLocalDir "apache-maven-3.9.6\bin\mvn.cmd"
    
    if (-not (Test-Path $mvnCmd)) {
        Write-Host "==> Maven not found globally. Downloading Apache Maven 3.9.6..."
        if (-not (Test-Path $mavenLocalDir)) {
            New-Item -ItemType Directory -Path $mavenLocalDir -Force | Out-Null
        }
        $zipPath = Join-Path $mavenLocalDir "maven.zip"
        $url = "https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip"
        
        Write-Host "Downloading Maven from $url ..."
        Invoke-WebRequest -Uri $url -OutFile $zipPath
        
        Write-Host "Extracting Maven..."
        Expand-Archive -Path $zipPath -DestinationPath $mavenLocalDir -Force
        
        Write-Host "Cleaning up zip..."
        Remove-Item $zipPath -Force
    }
    
    Write-Host "Using local Maven: $mvnCmd"
}

Write-Host "==> Building WAR..."
& $mvnCmd -q -DskipTests clean package
if ($LASTEXITCODE -ne 0) { throw "Maven build failed." }


# 3) Docker compose up
Write-Host "==> Starting MySQL + Tomcat containers..."
docker compose up -d --build

# 4) Wait for app
Write-Host "==> Waiting for app to be ready at http://localhost:8080/mulu-caves/home ..."
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
    try {
        $resp = Invoke-WebRequest -Uri "http://localhost:8080/mulu-caves/home" `
                                   -UseBasicParsing -TimeoutSec 3
        if ($resp.StatusCode -eq 200) { $ready = $true; break }
    } catch {}
    Start-Sleep -Seconds 2
}

if ($ready) {
    Write-Host ""
    Write-Host "App is up:" -ForegroundColor Green
    Write-Host "   Public site : http://localhost:8080/mulu-caves/home"
    Write-Host "   Admin login : http://localhost:8080/mulu-caves/admin/login  (admin / admin123)"
    Write-Host "   MySQL       : localhost:3307  (root / rootpw)"
} else {
    Write-Warning "App did not respond in time. Check 'docker compose logs'."
    exit 1
}