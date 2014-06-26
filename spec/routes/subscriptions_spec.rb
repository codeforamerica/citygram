require 'spec_helper'

describe Citygram::Routes::Subscriptions do
  include Citygram::Routes::TestHelpers

  let(:publisher) { create(:publisher) }

  describe 'GET /subscriptions/:id' do
    let(:subscription) { create(:subscription, publisher: publisher) }

    it 'responds with 200 OK' do
      get "/subscriptions/#{subscription.id}"
      expect(last_response.status).to eq 200
    end

    it 'returns the record' do
      get "/subscriptions/#{subscription.id}"
      expect(last_response.body).to eq subscription.to_json
    end

    context 'missing' do
      let(:max_id) { Subscription.max(:id) || 0 }

      it 'responds with 404 NOT FOUND' do
        get "/subscriptions/#{max_id + 1}"
        expect(last_response.status).to eq 404
      end

      it 'explains the error' do
        get "/subscriptions/#{max_id + 1}"
        error = { error: 'not found' }.to_json
        expect(last_response.body).to eq error
      end
    end
  end

  describe 'POST /subscriptions' do
    let(:params) {{ subscription: attributes_for(:subscription).merge(publisher_id: publisher.id) }}

    it 'responds with 201 CREATED' do
      post '/subscriptions', params
      expect(last_response.status).to eq 201
    end

    it 'creates a new record' do
      expect { post '/subscriptions', params }.to change{ Subscription.count }.by(+1)
    end

    it 'returns the record' do
      post '/subscriptions', params
      expect(last_response.body).to eq Subscription.last.to_json
    end
  end
end
