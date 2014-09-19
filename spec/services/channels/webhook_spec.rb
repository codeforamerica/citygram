require 'spec_helper'

describe Citygram::Services::Channels::Webhook do
  subject { Citygram::Services::Channels::Webhook }

  let(:subscription) { create(:subscription, channel: 'webhook') }
  let(:event) { create(:event) }

  let(:headers) { {'Content-Type'=>'application/json'} }
  let(:body) do
    JSON.pretty_generate(
      event: event.attributes,
      subscription: subscription.attributes,
      publisher: event.publisher.attributes
    )
  end

  context 'success' do
    it 'POSTs the event attributes to the subscription endpoint' do
      stub_request(:post, subscription.webhook_url).
        with(body: body, headers: headers).
        to_return(status: 200)

      subject.call(subscription, event)

      expect(a_request(:post, subscription.webhook_url).
        with(body: body, headers: headers)).to have_been_made.once
    end
  end

  context 'failure' do
    let(:failed_status) { (300..599).to_a.sample }

    it "raises an exception on non-2xx response" do
      stub_request(:post, subscription.webhook_url).
        with(body: body, headers: headers).
        to_return(status: failed_status)

      expect{ subject.call(subscription, event) }.
        to raise_error Citygram::Services::Channels::NotificationFailure, /HTTP status code: #{failed_status}/

      expect(a_request(:post, subscription.webhook_url).
        with(body: body, headers: headers)).to have_been_made.once
    end
  end
end
