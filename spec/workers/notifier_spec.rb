require 'spec_helper'

describe Georelevent::Workers::Notifier do
  subject { Georelevent::Workers::Notifier.new }
  let(:body) { event.attributes.to_json }
  let(:headers) { {'Content-Type'=>'application/json'} }
  let(:subscription) { create(:subscription) }
  let(:event) { create(:event) }

  before do
    stub_request(:post, subscription.endpoint).with(body: body, headers: headers)
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
