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
