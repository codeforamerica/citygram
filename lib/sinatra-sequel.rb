require 'sinatra/base'
require 'sequel'

module Sinatra
  module SequelHelper
    def database
      settings.database
    end
  end

  module SequelExtension
    def database=(url)
      @database = nil
      set :database_url, url
      database
    end

    def database
      @database ||= Sequel.connect(database_url, encoding: 'unicode')
    end

  protected

    def self.registered(app)
      app.set :database, ->{ ENV['DATABASE_URL'] || "postgres://localhost/georelevent_#{environment}" }

      if app.development?
        app.database.loggers << Logger.new(STDOUT)
      end

      app.helpers SequelHelper
    end
  end

  register SequelExtension
end
