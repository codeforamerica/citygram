ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require 'webmock/rspec'

# require the application
require_relative '../app'
require_relative '../lib/digest_helper'

# require test support files
Dir['spec/support/**/*.rb'].each { |f| require File.absolute_path(f) }

  
RSpec.configure do |config|
  config.include FixtureHelpers
  config.order = 'random'
  
  
end
