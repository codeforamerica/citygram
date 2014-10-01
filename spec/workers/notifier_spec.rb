require 'spec_helper'

describe Citygram::Workers::Notifier do
  subject { Citygram::Workers::Notifier.new }

  context 'notification per event' do
    let(:subscription) { create(:subscription, channel: 'webhook', webhook_url: 'https://example.com/path') }
    let(:event) { create(:event) }

    describe '#perform' do
      before do
        expect(Citygram::Services::Channels[subscription.channel]).to receive(:call).with(subscription, event)
      end

      it 'retrieves the event of interest' do
        expect(Event).to receive(:first!).with(id: event.id).and_return(event)
        subject.perform(subscription.id, event.id)
      end

      it 'retrieves the subscription of interest' do
        expect(Subscription).to receive(:first!).with(id: subscription.id).and_return(subscription)
        subject.perform(subscription.id, event.id)
      end
    end

    it 'limits the number of retries' do
      retries = Citygram::Workers::Notifier.sidekiq_options_hash["retry"]
      expect(retries).to eq 5
    end
  end

  context 'digested notifications' do
    it 'does not expect email channel to have an event' do
      subscription = create(:subscription, channel: 'email', email_address: 'a@b.cc')
      expect(Citygram::Services::Channels::Email).to receive(:call)
      subject.perform(subscription.id, nil)
    end
  end
end
