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
      @database ||= Sequel.connect(database_url)
    end

  protected

    def self.registered(app)
      app.set :database, ->{ ENV['DATABASE_URL'] || "postgres://localhost/georelevent_#{environment}" }
      app.helpers SequelHelper
    end
  end

  register SequelExtension
end
