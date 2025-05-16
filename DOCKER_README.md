# Docker Setup for Redis Rails Demo App

This document explains how to run the Redis Rails Demo application using Docker.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

The easiest way to run the application is using the provided script:

```bash
./docker-run.sh
```

This will build and start both the Rails application and Redis containers.

## Manual Setup

If you prefer to run commands manually:

1. Build the Docker images:

   ```bash
   docker-compose build
   ```

2. Start the containers:

   ```bash
   docker-compose up
   ```

3. To run in the background:

   ```bash
   docker-compose up -d
   ```

4. To stop the containers:
   ```bash
   docker-compose down
   ```

## Environment Variables

The application supports the following environment variables:

- `REDIS_URL`: URL for the Redis connection (default: `redis://redis:6379/0` in Docker)
- `RAILS_LOG_LEVEL`: Logging level (default: `debug` to show all Redis operations)

## Customizing the Redis Connection

To use a different Redis instance, you can set the `REDIS_URL` environment variable:

```bash
REDIS_URL=redis://your-redis-host:port/db docker-compose up
```

## Docker Compose Configuration

The `docker-compose.yml` file defines:

1. A Redis service using Redis 7
2. A web service running the Rails application connected to Redis

The Rails application automatically:

1. Connects to Redis using the provided URL
2. Performs continuous operations (insert, read, delete) on Redis
3. Logs all operations to stdout

## Container Logs

To view logs of running containers:

```bash
docker-compose logs -f
```

To view logs of a specific service:

```bash
docker-compose logs -f web   # For Rails application logs
docker-compose logs -f redis # For Redis logs
```
