# Configure Redis connection
require 'redis'

# Default Redis URL if not provided via environment variable
redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379'

# Log Redis configuration
Rails.logger.info("Configuring Redis with URL: #{redis_url.gsub(/:.*@/, ':****@')}")

# Configure the connection
begin
  # Test connection during initialization
  redis = Redis.new(url: redis_url)
  redis.ping
  Rails.logger.info('Successfully connected to Redis')
rescue Redis::BaseError => e
  Rails.logger.error("Failed to connect to Redis: #{e.message}")
  Rails.logger.error('Redis operations will fail until connection is established')
end
