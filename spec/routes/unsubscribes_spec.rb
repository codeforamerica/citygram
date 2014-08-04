require 'spec_helper'

describe Citygram::Routes::Unsubscribes do
  include Citygram::Routes::TestHelpers

  Citygram::Routes::Unsubscribes::FILTER_WORDS.each do |word|
    it "treats #{word} as a stop word" do
      phone = '+15555555555'
      subscription = create(:subscription, channel: 'sms', phone_number: phone)

      post '/unsubscribes', { 'Body' => word, 'From' => phone }

      expect(subscription.reload.unsubscribed_at).to be_present
    end
  end

  it 'does not unsubscribe if the message does not have a stop word' do
    phone = '+15555555555'
    subscription = create(:subscription, channel: 'sms', phone_number: phone)

    post '/unsubscribes', { 'Body' => 'just a plain sms :)', 'From' => phone }

    expect(subscription.reload.unsubscribed_at).to be_nil
  end
end
