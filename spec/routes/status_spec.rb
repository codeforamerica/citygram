require 'spec_helper'

describe Citygram::Routes::Status do
  include Citygram::Routes::TestHelpers

  let(:twilio_url) { ENV.fetch('TWILIO_URL') }

  describe 'GET /status' do
    it 'returns a non-empty body' do
        stub_request(:get, twilio_url).
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'api.twilio.com', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "", :headers => {})

        get '/status'
        expect(last_response.body).not_to be_empty
      end
  end
end
