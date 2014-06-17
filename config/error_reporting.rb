require 'airbrake'
require 'sidekiq'

Airbrake.configure do |config|
  config.api_key = ENV['ERRBIT_KEY']
  config.host    = ENV['ERRBIT_HOST']
  config.port    = 443
  config.secure  = true
end

Sidekiq.configure_server do |config|
  config.error_handlers << ->(ex, context){ Airbrake.notify_or_ignore(ex, parameters: context) }
end
