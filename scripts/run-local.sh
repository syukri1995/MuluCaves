#!/usr/bin/env bash
# ==========================================================
# Local development — bash / macOS / Linux
# ==========================================================
# Prereqs: Docker (Compose v2), JDK 25, Maven
# ==========================================================
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

# 1) Materialise db.properties
if [ ! -f src/main/webapp/WEB-INF/db.properties ]; then
    echo "==> Creating db.properties from template..."
    sed 's/changeme/rootpw/' src/main/webapp/WEB-INF/db.properties.template \
        > src/main/webapp/WEB-INF/db.properties
fi

# 2) Build
echo "==> Checking for Maven..."
if command -v mvn >/dev/null 2>&1; then
    MVN_CMD="mvn"
else
    MAVEN_LOCAL_DIR="$root/.maven"
    MVN_CMD="$MAVEN_LOCAL_DIR/apache-maven-3.9.6/bin/mvn"
    if [ ! -f "$MVN_CMD" ]; then
        echo "==> Maven not found globally. Downloading Apache Maven 3.9.6..."
        mkdir -p "$MAVEN_LOCAL_DIR"
        TAR_PATH="$MAVEN_LOCAL_DIR/maven.tar.gz"
        URL="https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz"
        echo "Downloading Maven from $URL ..."
        curl -fsSL -o "$TAR_PATH" "$URL"
        echo "Extracting Maven..."
        tar -xzf "$TAR_PATH" -C "$MAVEN_LOCAL_DIR"
        echo "Cleaning up tar..."
        rm "$TAR_PATH"
    fi
    echo "Using local Maven: $MVN_CMD"
fi

echo "==> Building WAR..."
"$MVN_CMD" -q -DskipTests clean package

# 3) Docker compose up
echo "==> Starting MySQL + Tomcat containers..."
docker compose up -d --build

# 4) Wait for app
echo "==> Waiting for app to respond..."
for i in $(seq 1 30); do
    if curl -fsS http://localhost:8080/mulu-caves/home > /dev/null 2>&1; then
        echo
        echo "App is up:"
        echo "   Public site : http://localhost:8080/mulu-caves/home"
        echo "   Admin login : http://localhost:8080/mulu-caves/admin/login  (admin / admin123)"
        echo "   MySQL       : localhost:3306  (root / rootpw)"
        exit 0
    fi
    sleep 2
done

echo "App did not respond in time. Run 'docker compose logs' to diagnose." >&2
exit 1