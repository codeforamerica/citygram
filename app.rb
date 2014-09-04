require 'bundler'
Bundler.require

# setup environment variables
require 'dotenv'
Dotenv.load

# setup load paths
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'sinatra/base'

module Citygram
  class App < Sinatra::Base
    configure do
      set :logger, Logger.new(test? ? nil : STDOUT)
      set :map_id, ENV.fetch('MAP_ID') { 'codeforamerica.inb9loae' }
    end

    configure :production do
      require 'newrelic_rpm'
      require 'sinatra-error-logging'

      require 'rack/ssl'
      use Rack::SSL
    end
  end
end

require 'app/models'
require 'app/routes'
require 'app/workers'

# Log instrumented requests for publisher and subscription connections
ActiveSupport::Notifications.subscribe(
  /^request\.(publisher|subscription)\./,
  Citygram::Services::ConnectionBuilder::RequestLog.new(Citygram::App.logger)
)
