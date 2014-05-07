require 'bundler'
Bundler.require

# setup environment variables
require 'dotenv'
Dotenv.load

# setup load paths
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'sinatra/base'
require 'sinatra/sequel'

require 'app/models'
require 'app/routes'

module Georelevent
  class App < Sinatra::Application
    configure do
      set :database, ->{ ENV['DATABASE_URL'] || "postgres://localhost/georelevent_#{environment}" }
    end

    configure :development, :staging do
      database.loggers << Logger.new(STDOUT)
    end

    use Routes::Home
  end
end
