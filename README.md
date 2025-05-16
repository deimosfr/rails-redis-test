# Rails Redis Operations App

A Rails application that connects to Redis 7 and performs continuous set/get/delete operations with random keys and values every second.

## Features

- Connects to Redis 7 using environment variables
- Performs set/get/delete operations with random keys every second
- Web interface to check Redis connection status
- Docker and docker-compose support for easy deployment

## Redis Libraries Used

- [redis-rb](https://github.com/redis/redis-rb) v5.3.0
- [redis-client](https://github.com/redis-rb/redis-client) v0.22.0

## Environment Variables

- `REDIS_URL`: Redis connection URL (default: `redis://localhost:6379`)
- `REDIS_OPERATIONS_ENABLED`: Set to `true` to enable continuous Redis operations (used in Docker)

## Running with Docker Compose

The easiest way to run the application is using Docker Compose:

```bash
# Generate a Rails master key if you don't have one
echo $(openssl rand -hex 16) > config/master.key

# Set the master key as an environment variable
export RAILS_MASTER_KEY=$(cat config/master.key)

# Make sure the Gemfile.lock includes Linux platforms
bundle lock --add-platform aarch64-linux x86_64-linux

# Build and start the containers
docker-compose up --build
```

The application will be available at http://localhost:3000

## Running Manually

### Prerequisites

- Ruby 3.2.2
- Redis 7

### Setup

1. Install dependencies:
```bash
bundle install
```

2. Start the Rails server:
```bash
REDIS_URL=redis://localhost:6379 rails server
```

3. In a separate terminal, run the continuous Redis operations:
```bash
rails redis:continuous_operations
```

## Docker

You can also build and run just the Docker container:

```bash
# Build the Docker image
docker build -t rails-redis-operations .

# Run the container
docker run -d -p 3000:80 \
  -e RAILS_MASTER_KEY=$(cat config/master.key) \
  -e REDIS_URL=redis://your-redis-host:6379 \
  -e REDIS_OPERATIONS_ENABLED=true \
  --name rails-redis-app \
  rails-redis-operations
```
