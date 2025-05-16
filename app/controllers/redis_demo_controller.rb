class RedisDemoController < ApplicationController
  def index
    # Use direct STDOUT to ensure visibility in Docker logs
    STDOUT.puts "\n\n===== REDIS OPERATIONS START ====="
    STDOUT.flush  # Ensure output is flushed immediately
    
    # Also write to stderr to maximize chances of visibility
    $stderr.puts "\n\n===== REDIS OPERATIONS LOG (STDERR) ====="
    $stderr.flush  # Ensure stderr is flushed immediately
    
    # Create a log array to store operations
    logs = []
    
    # Flag to indicate we should continue looping
    # Note: In a real-world application, you would use a better approach
    # for long-running operations, like background jobs
    @continue_flag = true
    
    # Track operation count
    count = 0
    
    # Create a response thread
    response_thread = Thread.new do
      # Return the logs in the response for easier viewing
      sleep 0.5  # Give the main thread a moment to start
      logs << "Redis operations will continue in the server logs."
      render plain: "Redis operations started and will run continuously on the server:\n\n#{logs.join("\n")}"
    end
    
    # Create a worker thread for Redis operations
    Thread.new do
      # Loop indefinitely
      while @continue_flag
        count += 1
        
        # Generate a random key and value
        random_key = "key_#{SecureRandom.hex(5)}"
        random_value = "value_#{SecureRandom.hex(10)}"
        
        # Log the operation with timestamp
        timestamp = Time.now.strftime("%H:%M:%S")
        log_message = "[#{timestamp}][#{count}] Inserting random key-value pair: #{random_key}=#{random_value}"
        STDOUT.puts log_message
        STDOUT.flush  # Force immediate output
        $stderr.puts "STDERR: #{log_message}"
        $stderr.flush  # Force immediate stderr output
        
        # Insert the random key-value pair into Redis
        REDIS.set(random_key, random_value)
        
        # Read the value back from Redis
        retrieved_value = REDIS.get(random_key)
        log_message = "[#{timestamp}][#{count}] Retrieved value for #{random_key}: #{retrieved_value}"
        STDOUT.puts log_message
        STDOUT.flush
        $stderr.puts "STDERR: #{log_message}"
        $stderr.flush
        
        # Delete the key
        REDIS.del(random_key)
        log_message = "[#{timestamp}][#{count}] Deleted key: #{random_key}"
        STDOUT.puts log_message
        STDOUT.flush
        $stderr.puts "STDERR: #{log_message}"
        $stderr.flush
        
        # Verify deletion
        if REDIS.get(random_key).nil?
          log_message = "[#{timestamp}][#{count}] Confirmed key deletion: #{random_key} no longer exists"
          STDOUT.puts log_message
          STDOUT.flush
          $stderr.puts "STDERR: #{log_message}"
          $stderr.flush
        else
          log_message = "[#{timestamp}][#{count}] Failed to delete key: #{random_key}"
          STDOUT.puts log_message
          STDOUT.flush
          $stderr.puts "STDERR: #{log_message}"
          $stderr.flush
        end
        
        log_message = "[#{timestamp}][#{count}] Sleeping for 1 second..."
        STDOUT.puts log_message
        STDOUT.flush
        $stderr.puts "STDERR: #{log_message}"
        $stderr.flush
        
        # Print a separator line to make the output more readable
        STDOUT.puts "-" * 80
        STDOUT.flush
        
        sleep 1
      end
    end
    
    # Join the response thread to ensure the response is sent
    response_thread.join
  end
end 