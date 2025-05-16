#!/bin/bash

echo "====================================="
echo "Running Redis Rails Demo Application"
echo "====================================="

# Default Redis URL points to our Docker container
export REDIS_URL="redis://localhost:6379/0"

echo "Redis URL set to: $REDIS_URL"
echo "Starting Rails server in the background..."

# Start the Rails server in the background
bin/rails server &
SERVER_PID=$!

# Give the server a moment to start up
sleep 3

echo "====================================="
echo "Making a request to the application..."
echo "====================================="

# Make a request to the application
curl -s http://localhost:3000

echo ""
echo "====================================="
echo "Stopping the server..."
echo "====================================="

# Kill the server
kill $SERVER_PID

echo "Done!" 