#!/bin/bash
# Helper script to build and run the Docker container

# Generate Rails master key if it doesn't exist
if [ ! -f config/master.key ]; then
  echo "Generating Rails master key..."
  echo $(openssl rand -hex 16) > config/master.key
  echo "Master key generated!"
fi

# Set the master key as an environment variable
export RAILS_MASTER_KEY=$(cat config/master.key)

# Make sure the Gemfile.lock includes Linux platforms
echo "Adding Linux platforms to Gemfile.lock..."
bundle lock --add-platform aarch64-linux x86_64-linux

# Build the Docker image
echo "Building Docker image..."
docker build -t rails-redis-operations .

# Run the container
echo "Running Docker container..."
docker run -d -p 3000:80 \
  -e RAILS_MASTER_KEY=$RAILS_MASTER_KEY \
  -e REDIS_URL="redis://host.docker.internal:6379" \
  -e REDIS_OPERATIONS_ENABLED=true \
  --name rails-redis-app \
  rails-redis-operations

echo "Container started! Access the application at http://localhost:3000"
echo "Check logs with: docker logs rails-redis-app -f"
