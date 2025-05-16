require 'redis'

STDOUT.puts "\n\n===== REDIS INITIALIZATION ====="
STDOUT.flush

# Configure Redis connection from environment variables
redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379/0'

# Log the Redis connection being established
STDOUT.puts "Connecting to Redis at #{redis_url}"
STDOUT.flush

begin
  REDIS = Redis.new(url: redis_url)
  
  # Test connection
  REDIS.ping
  
  STDOUT.puts "Successfully connected to Redis at #{redis_url}"
  STDOUT.puts "Connection test: PING returned #{REDIS.ping}"
  STDOUT.flush
rescue => e
  STDOUT.puts "Failed to connect to Redis at #{redis_url}: #{e.message}"
  STDOUT.flush
  raise e
end

STDOUT.puts "===== REDIS INITIALIZATION COMPLETE =====\n\n"
STDOUT.flush 