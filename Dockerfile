FROM ruby:3.2.2-slim

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_LEVEL=debug
# Force immediate output for better visibility
ENV STDOUT_SYNC=true
ENV STDERR_SYNC=true

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create application directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --without development test

# Copy the rest of the application
COPY . .

# Expose port 3000
EXPOSE 3000

# Create entrypoint script
RUN echo '#!/bin/bash\n\
    echo "===== Starting Rails App with Redis ====="\n\
    echo "REDIS_URL: $REDIS_URL"\n\
    \n\
    # Handle SECRET_KEY_BASE\n\
    if [ -z "$SECRET_KEY_BASE" ]; then\n\
    export SECRET_KEY_BASE=$(openssl rand -hex 64)\n\
    echo "Generated a random SECRET_KEY_BASE"\n\
    else\n\
    echo "Using SECRET_KEY_BASE from environment variable"\n\
    fi\n\
    \n\
    # Make sure logging environment variables are set\n\
    export RAILS_LOG_TO_STDOUT=true\n\
    export STDOUT_SYNC=true\n\
    export STDERR_SYNC=true\n\
    export RAILS_LOG_LEVEL=${RAILS_LOG_LEVEL:-debug}\n\
    \n\
    echo "Starting Rails server with enhanced logging..."\n\
    \n\
    # Use unbuffer to ensure output is shown immediately\n\
    rails server -b 0.0.0.0 &\n\
    SERVER_PID=$!\n\
    \n\
    sleep 3\n\
    \n\
    echo "===== Triggering Redis Operations ====="\n\
    # Show the output from curl instead of discarding it\n\
    curl -s http://localhost:3000 &\n\
    \n\
    echo "Redis operations now running continuously."\n\
    echo "All Redis operations should be visible in the logs below."\n\
    echo "Press Ctrl+C to stop."\n\
    echo "======================================"\n\
    \n\
    # Wait for the server process to finish\n\
    wait $SERVER_PID\n\
    ' > /app/docker-entrypoint.sh && chmod +x /app/docker-entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/app/docker-entrypoint.sh"] 