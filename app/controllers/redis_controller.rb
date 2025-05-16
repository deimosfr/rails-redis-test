class RedisController < ApplicationController
  def status
    redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379'
    @redis_url = redis_url.gsub(/:.*@/, ':****@') # Hide password in URL if present
    
    begin
      redis = Redis.new(url: redis_url)
      redis.ping
      @status = 'Connected'
      @redis_info = redis.info
    rescue Redis::BaseError => e
      @status = "Error: #{e.message}"
      @redis_info = {}
    end

    # Perform a single operation for display
    service = RedisOperationsService.new
    @operation = service.perform_operations
  end
end
