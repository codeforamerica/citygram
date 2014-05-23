require 'factory_girl'
require 'ffaker'

require 'spec/factories'

# setup factory girl shortcuts
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
