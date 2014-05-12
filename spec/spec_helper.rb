ENV['RACK_ENV'] = 'test'

require 'database_cleaner'
require 'factory_girl'
require 'ffaker'
require 'rack/test'
require 'rspec'

begin
  require 'debugger'
rescue LoadError
end

# require the application
require_relative '../app'

module Georelevent::Routes
  module TestHelpers
    include Rack::Test::Methods

    def app
      subject
    end
  end
end

# setup factory girl shortcuts
require 'spec/factories'
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

DatabaseCleaner[:sequel, connection: Sequel::Model.db].strategy = :transaction

RSpec.configure do |config|
  config.around do |example|
    DatabaseCleaner[:sequel, connection: Sequel::Model.db].start
    example.run
    DatabaseCleaner[:sequel, connection: Sequel::Model.db].clean
  end
end
