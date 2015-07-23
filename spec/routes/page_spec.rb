require 'spec_helper'

describe Citygram::Routes::Page do
  include Citygram::Routes::TestHelpers

  describe 'GET /' do
    before do
      ENV.delete 'ROOT_CITY_TAG'
    end
    context 'ROOT_CITY_TAG is set' do
      before do
        ENV['ROOT_CITY_TAG'] = 'new-york'
      end

      it 'responds with 200 OK' do
        get '/'
        expect(last_response.status).to eq 200
      end

      it 'returns a non-empty body' do
        get '/'
        expect(last_response.body).not_to be_empty
      end
    end

    context 'ROOT_CITY_TAG is not set' do
      it 'raises an exception' do
        expect do
          get '/'
        end.to raise_error Citygram::Models::City::NotFound
      end
    end
  end
end
