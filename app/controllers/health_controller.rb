class HealthController < ApplicationController
  def check
    redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379'
    
    begin
      redis = Redis.new(url: redis_url)
      redis.ping
      
      render json: {
        status: 'ok',
        redis: 'connected',
        time: Time.now.iso8601
      }
    rescue Redis::BaseError => e
      render json: {
        status: 'error',
        redis: "disconnected: #{e.message}",
        time: Time.now.iso8601
      }, status: :service_unavailable
    end
  end
end
