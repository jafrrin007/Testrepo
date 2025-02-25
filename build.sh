#!/bin/bash
# build.sh

# Stop and remove the existing container (if any)
docker-compose down

# Build the Docker image
docker-compose build

# Start the Docker container
docker-compose up -d
