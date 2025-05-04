#!/bin/bash

set -e

# 1. Pull latest from GitHub
echo "Pulling the latest changes from GitHub"
git pull origin testing

# 2. Load .env file
echo "Loading environment variables..."
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo ".env file not found!"
    exit 1
fi

# 4. Deploy the stack
echo "Deploying Docker stack..."
docker stack deploy \
  --with-registry-auth \
  --compose-file docker-stack.yml \
  myapp

echo "Deployment complete!"