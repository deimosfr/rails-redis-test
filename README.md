# Redis Demo Rails Application

This is a simple Rails application that demonstrates Redis operations. It connects to Redis via an environment variable, inserts a random key-value pair, reads it, and then deletes it, all while logging the operations.

## Prerequisites

- Ruby 3.2.2 (or compatible version)
- Rails 8.0.2
- Docker (for running Redis)

## Redis Gems

This application uses the following Redis gems with specific versions:

- redis 5.3.0
- redis-client 0.22.0

## Setup

1. Clone the repository
2. Install dependencies:
   ```
   bundle install
   ```
3. Start Redis using Docker:
   ```
   docker build -t my-redis -f ../Dockerfile ..
   docker run -d -p 6379:6379 --name redis-container my-redis
   ```
4. Start the Rails application:
   ```
   ./bin/start_with_redis.sh
   ```

## How It Works

When you visit the root URL or `/redis_demo`, the application will:

1. Generate a random key and value
2. Insert it into Redis
3. Read it back from Redis
4. Delete it from Redis
5. Verify the deletion
6. Log all operations

Check the Rails logs to see the operations in action.

## Redis Environment Variable

The application uses the `REDIS_URL` environment variable to connect to Redis. The default value is set to `redis://localhost:6379/0` if the environment variable is not provided.

You can customize the Redis connection by setting the `REDIS_URL` environment variable before starting the application:

```
export REDIS_URL="redis://your-redis-host:port/db"
./bin/start_with_redis.sh
```
