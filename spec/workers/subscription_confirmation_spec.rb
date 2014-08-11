require 'spec_helper'

describe Citygram::Workers::SubscriptionConfirmation do
  subject { Citygram::Workers::SubscriptionConfirmation.new }

  context 'sms' do
    let(:publisher) { subscription.publisher }
    let!(:subscription) { create(:subscription, channel: 'sms', phone_number: '212-555-1234') }

    before do
      stub_request(:post, "https://dev-account-sid:dev-auth-token@api.twilio.com/2010-04-01/Accounts/dev-account-sid/Messages.json").
        with(body: {
          "Body"=>"Welcome! You are now subscribed to #{publisher.title} in #{publisher.city}. Woohoo! If you'd like to give feedback, text back with your email. To unsubcribe from all messages, reply STOP.",
          "From"=>"15555555555",
          "To"=>"212-555-1234"}).
        to_return(status: 200, body: {
          'sid' => 'SM10ea1dce707f4bedb44204c9fbc02e39',
          'to' => subscription.phone_number,
          'from' => '15555555555',
          'body' => "You are now subscribed to #{subscription.publisher.title} in #{subscription.publisher.city}. Woohoo! If you'd like to give feedback, text back with your email. To unsubcribe from all messages, reply STOP.",
          'status' => 'queued'
        }.to_json)
    end

    it 'retrieves the subscription of interest' do
      expect(Subscription).to receive(:first!).with(id: subscription.id).and_return(subscription)
      subject.perform(subscription.id)
    end

    it 'logs exceptions from twilio and retries' do
      error = Twilio::REST::RequestError.new('test failure', 1234)
      expect(Citygram::App.logger).to receive(:error).with(error)
      expect(Citygram::Services::Channels::SMS).to receive(:sms).and_raise(error)

      expect {
        subject.perform(subscription.id)
      }.to raise_error Citygram::Services::Channels::NotificationFailure, /test failure/
    end
  end

  it 'limits the number of retries' do
    retries = Citygram::Workers::SubscriptionConfirmation.sidekiq_options_hash["retry"]
    expect(retries).to eq 5
  end
end
