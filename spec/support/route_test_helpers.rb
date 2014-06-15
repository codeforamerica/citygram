module Citygram::Routes
  module TestHelpers
    include Rack::Test::Methods

    def app
      subject
    end
  end
end
