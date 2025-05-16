namespace :redis do
  desc 'Continuously perform Redis operations (set/get/delete) every second'
  task continuous_operations: :environment do
    require_relative '../../app/services/redis_operations_service'
    
    puts "Starting continuous Redis operations..."
    puts "Redis URL: #{ENV['REDIS_URL'] || 'redis://localhost:6379 (default)'}"
    puts "Press Ctrl+C to stop"
    
    service = RedisOperationsService.new
    
    loop do
      begin
        result = service.perform_operations
        if result[:success]
          puts "#{Time.now} - Operation completed successfully with key: #{result[:key]}"
        else
          puts "#{Time.now} - Operation failed: #{result[:error]}"
        end
      rescue StandardError => e
        puts "#{Time.now} - Error: #{e.message}"
      end
      
      sleep 1
    end
  end
end
