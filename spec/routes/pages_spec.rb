require 'spec_helper'

describe Citygram::Routes::Pages do
  include Citygram::Routes::TestHelpers

  describe 'GET /' do
    it 'redirects to official citygram' do
      get '/'
      expect(last_response.status).to eq 302
    end
  end
end
