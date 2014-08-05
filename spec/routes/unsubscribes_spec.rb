require 'spec_helper'

describe Citygram::Routes::Unsubscribes do
  include Citygram::Routes::TestHelpers

  let(:phone) { '+15555555555' }

  context 'invalid authentication' do
    it 'responds with 401 UNAUTHORIZED give no authentication' do
      subscription = create(:subscription, channel: 'sms', phone_number: phone)
      post '/unsubscribes', { 'Body' => 'STOP', 'From' => phone }
      expect(last_response.status).to eq 401
      expect(subscription.unsubscribed_at).to be_nil
    end

    it 'responds with 401 UNAUTHORIZED given invalid authentication' do
      authorize 'foo', 'bar'
      subscription = create(:subscription, channel: 'sms', phone_number: phone)
      post '/unsubscribes', { 'Body' => 'STOP', 'From' => phone }
      expect(last_response.status).to eq 401
      expect(subscription.unsubscribed_at).to be_nil
    end
  end

  context 'authenticated' do
    before do
      authorize ENV.fetch('BASIC_AUTH_USERNAME'), ENV.fetch('BASIC_AUTH_PASSWORD')
    end

    Citygram::Routes::Unsubscribes::FILTER_WORDS.each do |word|
      it "treats #{word} as a stop word" do
        subscription = create(:subscription, channel: 'sms', phone_number: phone)
        post '/unsubscribes', { 'Body' => word, 'From' => phone }
        expect(subscription.reload.unsubscribed_at).to be_present
      end

      it 'responds with 200 OK' do
        subscription = create(:subscription, channel: 'sms', phone_number: phone)
        post '/unsubscribes', { 'Body' => word, 'From' => phone }
        expect(last_response.status).to eq 200
      end
    end

    it 'does not unsubscribe if the message does not have a stop word' do
      subscription = create(:subscription, channel: 'sms', phone_number: phone)
      post '/unsubscribes', { 'Body' => 'just a plain sms :)', 'From' => phone }
      expect(subscription.reload.unsubscribed_at).to be_nil
    end
  end
end
