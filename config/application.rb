require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RedisApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
    
    # Configure the logger to use colorized format
    config.log_formatter = proc do |severity, datetime, progname, msg|
      color = case severity
              when "DEBUG" then "\033[0;37m" # White
              when "INFO" then "\033[0;32m" # Green
              when "WARN" then "\033[0;33m" # Yellow
              when "ERROR" then "\033[0;31m" # Red
              when "FATAL" then "\033[0;35m" # Purple
              else "\033[0m" # Reset
              end
      reset_color = "\033[0m"
      "#{color}[#{severity}] [#{datetime}] #{msg}#{reset_color}\n"
    end
  end
end
