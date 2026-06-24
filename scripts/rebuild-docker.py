#!/usr/bin/env python3
import os
import sys
import subprocess
import shutil
from pathlib import Path

# Move to the project root directory (parent of scripts/)
script_dir = Path(__file__).resolve().parent
project_root = script_dir.parent
os.chdir(project_root)

print(f"==> Working directory set to: {project_root}")

def find_maven():
    # 1. Check if global mvn command is available in PATH
    mvn_path = shutil.which("mvn")
    if mvn_path:
        print(f"--> Found system Maven: {mvn_path}")
        return "mvn"

    # 2. Check for local Maven installation
    local_maven_dir = project_root / ".maven" / "apache-maven-3.9.6"
    if os.name == "nt":  # Windows
        mvn_bin = local_maven_dir / "bin" / "mvn.cmd"
    else:  # Unix
        mvn_bin = local_maven_dir / "bin" / "mvn"

    if mvn_bin.exists():
        print(f"--> Found local Maven: {mvn_bin}")
        return str(mvn_bin)

    print("Error: Maven was not found globally in PATH or locally in .maven/ directory.")
    sys.exit(1)

def run_command(command, shell=False):
    print(f"Executing: {' '.join(command) if isinstance(command, list) else command}")
    try:
        result = subprocess.run(command, check=True, shell=shell)
        return result
    except subprocess.CalledProcessError as e:
        print(f"Error: Command failed with exit code {e.returncode}", file=sys.stderr)
        sys.exit(e.returncode)

def main():
    # 1. Find Maven executable
    mvn_cmd = find_maven()

    # 2. Compile and package the WAR archive
    print("\n==> 1. Packaging Web Application with Maven...")
    # Using shell=True for windows command prompt script compatibility
    is_windows = (os.name == "nt")
    run_command([mvn_cmd, "-DskipTests", "clean", "package"], shell=is_windows)

    # 3. Stop running docker containers
    print("\n==> 2. Stopping existing Docker containers...")
    run_command(["docker", "compose", "down"])

    # 4. Start the application service (app)
    print("\n==> 3. Starting Tomcat container...")
    # We start 'app' specifically since we use the host MySQL server
    run_command(["docker", "compose", "up", "-d", "app"])

    print("\n==> Success! The application is spinning up.")
    print("    Public site : http://localhost:8080/mulu-caves/home")
    print("    Admin login : http://localhost:8080/mulu-caves/admin/login")

if __name__ == "__main__":
    main()
