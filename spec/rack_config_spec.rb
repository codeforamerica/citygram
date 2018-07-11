require 'spec_helper'

describe 'config.ru' do
  include Rack::Test::Methods

  def app
    ENV['CORS_ALLOWED_ORIGINS'] = 'http://example.com'
    Rack::Builder.parse_file(File.expand_path('../../config.ru', __FILE__)).first
  end

  context 'when $CORS_ALLOWED_ORIGINS is set' do
    context 'when disallowed origin is specified' do
      it 'does not set CORS headers if bad origin' do
        header 'Origin', 'http://foobar.com'
        options '/publishers'
        expect(last_response.headers).to_not include('Access-Control-Allow-Origin')
      end
    end

    context 'when allowed origin is specified' do
      it 'sets CORS headers' do
        header 'Origin', 'http://example.com'
        header 'Access-Control-Request-Method', 'GET'
        header 'Access-Control-Request-Headers', 'Content-Type'
        options '/'

        expect(last_response.headers['Access-Control-Allow-Origin']).to eq 'http://example.com'
        expect(last_response.headers['Access-Control-Allow-Headers']).to eq 'Content-Type'
        expect(last_response.headers['Access-Control-Allow-Methods']).to eq 'GET'
      end
    end
  end
end
