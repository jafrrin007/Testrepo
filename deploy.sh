#!/bin/bash
# deploy.sh

# Pull the latest image from Docker Hub (dev or prod repo)
docker pull <dockerhub-username>/dev:latest

# Stop and remove the existing container
docker-compose down

# Start the container with the new image
docker-compose up -d
