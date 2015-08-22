require 'spec_helper'

describe Citygram::Workers::ReminderNotification do
  let(:reminder){ Citygram::Workers::ReminderNotification.new }
  let(:publisher) { subscription.publisher }
  let!(:subscription) { create(:subscription, channel: 'sms', phone_number: '212-555-1234', last_notified: 3.weeks.ago) }
  
  subject { reminder }

  describe 'notification message' do

    before(:each) do
      @subscription = subscription
      allow(@subscription).to receive(:deliveries_since_last_notification){ 28 }
    end

    subject{ reminder.reminder_message(@subscription) }

    it "should include activity" do
      expect(subject).to match("28")
    end

    it "should include publisher title" do
      expect(subject).to match(@subscription.publisher.title)
    end

    it "should include publisher city" do
      expect(subject).to match(@subscription.publisher.city)
    end

    it "shoud include a date format" do
      expect(subject).to match(@subscription.last_notification.strftime("%b %d, %Y"))
    end

    it "should be shortish" do
      expect(subject.length).to be <= 140
    end

  end
  
  context 'sending' do

    before do
      body_1 = subject.reminder_message(subscription)
      body_2 = subject.unsub_message(subscription)
      [body_1, body_2].each do |body|
        stub_request(:post, "https://dev-account-sid:dev-auth-token@api.twilio.com/2010-04-01/Accounts/dev-account-sid/Messages.json").
          with(body: {
            "Body" => body,
            "From"=>"15555555555",
            "To"=>"212-555-1234"}).
          to_return(status: 200, body: {
            'sid' => 'SM10ea1dce707f4bedb44204c9fbc02e39',
            'to' => subscription.phone_number,
            'from' => '15555555555',
            'body' => body,
            'status' => 'queued'
          }.to_json)
        end
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

    Citygram::Services::Channels::SMS::UNSUBSCRIBE_ERROR_CODES.each do |error_code|
      context "Twilio Error Code: #{error_code}" do
        it 'deactivates the subscription' do
          error = Twilio::REST::RequestError.new('test failure', error_code)
          expect(Citygram::Services::Channels::SMS).to receive(:sms).and_raise(error)

          expect {
            subject.perform(subscription.id)
          }.to change{ subscription.reload.unsubscribed_at.present? }.from(false).to(true)
        end
      end
    end
  end

  it 'limits the number of retries' do
    retries = Citygram::Workers::ReminderNotification.sidekiq_options_hash["retry"]
    expect(retries).to eq 5
  end
  

end