require 'redis'
require 'securerandom'

class RedisOperationsService
  def initialize
    @redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379'
    @redis = Redis.new(url: @redis_url)
  end

  def perform_operations
    # Generate a random key and value
    key = "key_#{SecureRandom.hex(8)}"
    value = "value_#{SecureRandom.hex(16)}"
    
    # Log operations
    Rails.logger.info("Performing Redis operations with key: #{key}")
    
    # SET operation
    @redis.set(key, value)
    Rails.logger.info("SET: #{key} => #{value}")
    
    # GET operation
    retrieved_value = @redis.get(key)
    Rails.logger.info("GET: #{key} => #{retrieved_value}")
    
    # DELETE operation
    @redis.del(key)
    Rails.logger.info("DEL: #{key} => Key deleted")
    
    # Verify deletion
    if @redis.get(key).nil?
      Rails.logger.info("Verified key deletion: #{key} no longer exists")
    end

    # Return success status
    { success: true, key: key, value: value }
  rescue Redis::BaseError => e
    Rails.logger.error("Redis operation failed: #{e.message}")
    { success: false, error: e.message }
  end
end
