#!/bin/bash

echo "====================================="
echo "Starting Redis Rails Demo Application"
echo "====================================="

# Default Redis URL points to our Docker container
export REDIS_URL="redis://localhost:6379/0"

echo "Redis URL set to: $REDIS_URL"
echo "Starting Rails server..."
echo "Visit http://localhost:3000 to start the continuous Redis operations"
echo "You will see logs continuously printed here as operations are performed"
echo "Press Ctrl+C to stop the server when done"
echo "====================================="

# Start the Rails server
bin/rails server 