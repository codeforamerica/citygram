require 'spec_helper'

describe Citygram::Workers::Notifier do
  subject { Citygram::Workers::Notifier.new }
  let(:body) { event.attributes.to_json }
  let(:headers) { {'Content-Type'=>'application/json'} }
  let(:subscription) { create(:subscription) }
  let(:event) { create(:event) }

  context 'success' do
    before do
      stub_request(:post, subscription.endpoint).
        with(body: body, headers: headers).
        to_return(status: 200)
    end

    it 'retrieves the event of interest' do
      expect(Event).to receive(:first!).with(id: event.id).and_return(event)
      subject.perform(subscription.id, event.id)
    end

    it 'retrieves the subscription of interest' do
      expect(Subscription).to receive(:first!).with(id: subscription.id).and_return(subscription)
      subject.perform(subscription.id, event.id)
    end

    it 'POSTs the event attributes to the subscription endpoint' do
      subject.perform(subscription.id, event.id)
      expect(a_request(:post, subscription.endpoint).
        with(body: body, headers: headers)).to have_been_made
    end
  end

  context 'failure' do
    let(:failed_status) { (300..599).to_a.sample }

    before do
      stub_request(:post, subscription.endpoint).
        with(body: body, headers: headers).
        to_return(status: failed_status)
    end

    it "raises an exception on non-2xx response" do
      expect{ subject.perform(subscription.id, event.id) }.
        to raise_error Citygram::Workers::Notifier::NotificationFailure, /HTTP status code: #{failed_status}/
    end
  end
end
