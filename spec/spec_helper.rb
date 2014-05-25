ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require 'webmock/rspec'

begin
  require 'debugger'
rescue LoadError
end

# require the application
require_relative '../app'

# require test support files
Dir['spec/support/**/*.rb'].each { |f| require File.absolute_path(f) }
