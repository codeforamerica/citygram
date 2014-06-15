require 'spec_helper'

describe Citygram::Routes::Home do
  include Citygram::Routes::TestHelpers

  describe 'GET /' do
    it 'responds with 200 OK' do
      get '/'
      expect(last_response.status).to eq 200
    end

    it 'returns a non-empty body' do
      get '/'
      expect(last_response.body).not_to be_empty
    end
  end
end
