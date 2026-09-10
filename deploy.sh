#!/bin/bash
IMAGE_TAG=$1

echo "Starting rolling deployment for tag: ${IMAGE_TAG}..."

# Stop old rollback/temp containers if present
docker rm -f web-app-old 2>/dev/null || true

# Rename existing live container to old
if [ $(docker ps -q -f name=web-app-live) ]; then
    docker rename web-app-live web-app-old
fi

# Start new version on port 8081
docker run -d --name web-app-live -p 8081:80 ${IMAGE_TAG}

# Verify deployment health
sleep 3
if curl -f http://localhost:8081; then
    echo "Deployment verified successfully!"
    docker rm -f web-app-old 2>/dev/null || true
else
    echo "Deployment health check failed! Initiating rollback..."
    docker rm -f web-app-live
    docker rename web-app-old web-app-live 2>/dev/null || true
    exit 1
fi
