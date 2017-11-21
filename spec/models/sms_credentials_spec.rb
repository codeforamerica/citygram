require 'spec_helper'

describe Citygram::Models::SmsCredentials do
  it 'should be retrievable from the factory' do
    creds = build(:sms_credentials)
    expect(creds).to be_valid
  end
  
  it 'should require a from number' do
    creds = build(:sms_credentials, from_number: nil)
    expect(creds).not_to be_valid
  end
  
  it 'should require a sid' do
    creds = build(:sms_credentials, account_sid: nil)
    expect(creds).not_to be_valid
  end
  
  it 'should require an auth_token' do
    creds = build(:sms_credentials, auth_token: nil)
    expect(creds).not_to be_valid
  end  
end