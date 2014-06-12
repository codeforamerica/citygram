require 'airbrake'
require 'sidekiq'

Airbrake.configure do |config|
  config.api_key = ENV['ERRBIT_KEY']
  config.host    = ENV['ERRBIT_HOST']
  config.port    = 80
  config.secure  = config.port == 443
end

Sidekiq.configure_server do |config|
  config.error_handlers << Airbrake.method(:notify)
end
