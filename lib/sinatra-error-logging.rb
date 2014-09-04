require 'sidekiq'

module Sinatra
  module ErrorLoggingExtension
    def self.registered(app)
      return unless ENV['ERROR_LOG_KEY'] && ENV['ERROR_LOG_HOST']

      require 'airbrake'
      Airbrake.configure do |config|
        config.api_key = ENV['ERROR_LOG_KEY']
        config.host    = ENV['ERROR_LOG_HOST']
        config.port    = ENV['ERROR_LOG_PORT'] || 443
        config.secure  = config.port == 443
      end

      # https://github.com/airbrake/airbrake/issues/269#issuecomment-53260596
      Sidekiq.configure_server do |config|
        config.error_handlers << lambda do |exception, context|
          Airbrake.notify_or_ignore(exception, parameters: context)
        end
      end

      app.use Airbrake::Sinatra
    end
  end

  register ErrorLoggingExtension
end
