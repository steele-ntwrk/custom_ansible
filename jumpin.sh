#!/bin/bash
# ansible_shell.sh
# Drop into an interactive shell of the running netbox-ansible container

CONTAINER="netbox-ansible"

# Check if the container is running
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER}\$"; then
  echo "Container ${CONTAINER} is not running."
  exit 1
fi

# Drop into bash (fall back to sh if bash not present)
docker exec -it "$CONTAINER" bash 2>/dev/null || docker exec -it "$CONTAINER" sh
