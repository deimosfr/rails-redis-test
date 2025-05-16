#!/bin/bash

echo "====================================="
echo "Building and running Redis Rails app in Docker"
echo "====================================="

# Build and run the containers
docker-compose up --build

# The command above will run in the foreground
# To run in background, use:
# docker-compose up --build -d 