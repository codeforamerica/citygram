require 'bundler'
Bundler.require

# setup environment variables
require 'dotenv'
Dotenv.load

# setup load paths
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'sinatra/base'
require 'sinatra-sequel'

require 'app/routes'

module Georelevent
  class App < Sinatra::Application
    configure do
      set :logger, Logger.new(STDOUT)
    end

    configure :production do
      require 'newrelic_rpm'
    end

    use Routes::Home
  end

  class API < Grape::API
    mount Routes::Publishers
    mount Routes::Subscriptions

    require 'sidekiq/web'
    mount Sidekiq::Web => '/_jobs'
  end
end

require 'app/workers'
require 'app/models'
include Georelevent::Models
