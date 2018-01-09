require 'spec_helper'

describe Citygram::Routes::Subscriptions do
  include Citygram::Routes::TestHelpers

  let(:publisher) { create(:publisher) }

  describe 'POST /subscriptions' do
    let(:params) {{ subscription: attributes_for(:subscription).merge(publisher_id: publisher.id) }}

    it 'responds with 201 CREATED' do
      put '/subscriptions', params
      expect(last_response.status).to eq 201
    end

    it 'creates a new record' do
      expect { put '/subscriptions', params }.to change{ Subscription.count }.by(+1)
    end

    it 'does not create duplicate phone records' do
      # params sets webhook by default
      params[:subscription].merge!({channel: 'sms', phone_number: '123-123-1234', webhook_url: nil})
      expect { put '/subscriptions', params }.to change{ Subscription.count }.by(+1)
      expect { put '/subscriptions', params }.to change{ Subscription.count }.by(0)
    end

    it 'does not create duplicate email records' do
      # params sets webhook by default
      params[:subscription].merge!({channel: 'email', email_address: 'a@b.com', webhook_url: nil})
      expect { put '/subscriptions', params }.to change{ Subscription.count }.by(+1)
      expect { put '/subscriptions', params }.to change{ Subscription.count }.by(0)
    end

    it 'creates a record after previous unsubscribe' do
      subscription = Subscription.create!(params[:subscription])
      subscription.unsubscribe!
      expect { put '/subscriptions', params }.to change{ Subscription.count }.by(+1)
    end

    it 'returns the record' do
      put '/subscriptions', params
      expect(last_response.body).to eq Subscription.last.to_json
    end

    it 'queues a subscription confirmation job' do
      expect {
        put '/subscriptions', params
      }.to change{ Citygram::Workers::SubscriptionConfirmation.jobs.count }.by(+1)
    end

    it 'response with an error message if validations fail' do
      params[:subscription][:geom] = ''
      error_response = { error: 'geom is not present, geom is an invalid geometry' }.to_json

      put '/subscriptions', params
      expect(last_response.body).to eq error_response
    end
  end
end
