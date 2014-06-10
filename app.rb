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

require 'sidekiq'
require 'app/workers'

require 'app/routes'

module Georelevent
  class App < Sinatra::Application
    use Routes::Home
  end

  class API < Grape::API
    mount Routes::Publishers
    mount Routes::Subscriptions

    require 'sidekiq/web'
    mount Sidekiq::Web => '/_jobs'
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end

require 'app/models'
include Georelevent::Models
