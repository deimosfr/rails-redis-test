FROM ruby:3.2.2-slim

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true

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
    rails server -b 0.0.0.0 &\n\
    SERVER_PID=$!\n\
    sleep 3\n\
    echo "===== Triggering Redis Operations ====="\n\
    curl -s http://localhost:3000 > /dev/null &\n\
    echo "Redis operations running. Press Ctrl+C to stop."\n\
    wait $SERVER_PID\n\
    ' > /app/docker-entrypoint.sh && chmod +x /app/docker-entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/app/docker-entrypoint.sh"] 