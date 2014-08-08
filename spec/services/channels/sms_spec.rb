require 'spec_helper'

describe Citygram::Services::Channels::SMS do
  subject { Citygram::Services::Channels::SMS }

  let(:subscription) { create(:subscription, channel: 'sms', phone_number: '+15559874567') }
  let(:event) { create(:event) }

  let(:from_number) { ENV.fetch('TWILIO_FROM_NUMBER') }
  let(:account_sid) { ENV.fetch('TWILIO_ACCOUNT_SID') }
  let(:auth_token) { ENV.fetch('TWILIO_AUTH_TOKEN') }
  let(:sms_endpoint) do
    "https://%s:%s@api.twilio.com/2010-04-01/Accounts/%s/Messages.json" % [account_sid, auth_token, account_sid]
  end

  let(:request_headers) do
    {
      'Accept' => 'application/json',
      'Accept-Charset' => 'utf-8',
      'Content-Type' => 'application/x-www-form-urlencoded',
      'User-Agent' => /twilio-ruby/
    }
  end
  let(:request_body) do
    {
      'Body' => event.title,
      'From' => from_number,
      'To' => subscription.phone_number
    }
  end

  let(:response_headers) do
    {
      'Content-Type' => 'application/json',
      'X-Shenanigans' => 'none'
    }
  end
  let(:response_body) do
    {
      'sid' => 'SM10ea1dce707f4bedb44204c9fbc02e39',
      'to' => subscription.phone_number,
      'from' => from_number,
      'body' => event.title,
      'status' => 'queued'
    }.to_json
  end

  context 'success' do
    it 'sends an sms to the contact' do
      stub_request(:post, sms_endpoint).
        with(body: request_body, headers: request_headers).
        to_return(status: 201, body: response_body, headers: response_headers)

      subject.call(subscription, event)

      expect(a_request(:post, sms_endpoint).
        with(body: request_body, headers: request_headers)).to have_been_made.once
    end
  end

  context 'failure' do
    let(:response_headers) do
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/x-www-form-urlencoded'
      }
    end
    let(:response_body) do
      {
        'code' => 21211,
        'message' => "The 'To' number #{subscription.phone_number} is not a valid phone number.",
        'more_info' => 'https://www.twilio.com/docs/errors/21211',
        'status' => 400
      }.to_json
    end

    it 'raises a failed notification exception' do
      stub_request(:post, sms_endpoint).
        with(body: request_body, headers: request_headers).
        to_return(status: 400, body: response_body, headers: response_headers)

      expect { subject.call(subscription, event) }.
        to raise_error Citygram::Services::Channels::NotificationFailure

      expect(a_request(:post, sms_endpoint).
        with(body: request_body, headers: request_headers)).to have_been_made.once
    end

    context 'user has unsubscribed with filter word' do
      it 'deactivates the subscription if the user has replied with a filter word' do
        unsubscribed_error = Twilio::REST::RequestError.new('dummy message', Citygram::Services::Channels::SMS::UNSUBSCRIBED_ERROR_CODE)
        args = { from: from_number, to: subscription.phone_number, body: event.title }

        expect(Citygram::Services::Channels::SMS).to receive(:sms).
          with(args).
          and_raise(unsubscribed_error)

        expect {
          subject.call(subscription, event)
        }.to change{ subscription.reload.unsubscribed_at.present? }.from(false).to(true)
      end
    end
  end
end
