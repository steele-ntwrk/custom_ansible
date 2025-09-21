#!/bin/bash
# new_project.sh
# Create a new project in /work using the skeleton

set -e

TARGET="$1"
if [ -z "$TARGET" ]; then
  echo "Usage: new_project.sh <project_name>"
  exit 1
fi

WORKDIR="/work"
SKELETON="/opt/ansible-skel"

# Ensure /work exists
mkdir -p "$WORKDIR"

# Create the new project directory
mkdir -p "$WORKDIR/$TARGET"

# Resolve path *after* creation
TARGET_PATH="$(realpath "$WORKDIR/$TARGET")"

# Copy skeleton into the project
cp -rT "$SKELETON" "$TARGET_PATH"

echo "New Ansible project created at: $TARGET_PATH"
