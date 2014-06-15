require 'spec_helper'

describe Citygram::Routes::Publishers do
  include Citygram::Routes::TestHelpers

  describe 'GET /publishers' do
    let(:params) {{ page: 2, per: 2 }}
    let!(:publishers) { create_list(:publisher, 5) }

    it 'responds with 200 OK' do
      get '/publishers', params
      expect(last_response.status).to eq 200
    end

    it 'returns the list of publishers' do
      get '/publishers', params
      expect(last_response.body).to eq [publishers[2], publishers[1]].to_json
    end
  end
end
