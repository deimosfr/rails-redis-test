#!/bin/bash

echo "====================================="
echo "Starting Redis Rails Demo Application with Auto-Trigger"
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
echo "Auto-triggering Redis operations by making a request..."
echo "====================================="

# Make the initial request to trigger Redis operations
curl -s http://localhost:3000 > /dev/null &

echo "Request sent! Redis operations should now be running continuously."
echo "Watch the logs below. Press Ctrl+C to stop."
echo "====================================="

# Wait for the server process to finish (when user hits Ctrl+C)
wait $SERVER_PID 