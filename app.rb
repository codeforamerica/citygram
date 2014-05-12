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
    use Routes::Home
  end

  class API < Grape::API
    use Routes::Subscriptions
  end
end

require 'app/models'
include Georelevent::Models
