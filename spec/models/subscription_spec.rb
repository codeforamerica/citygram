require 'spec_helper'

describe Citygram::Models::Subscription do
  it 'belongs to a publisher' do
    publisher = create(:publisher)
    subscription = create(:subscription, publisher: publisher).reload 
    expect(subscription.publisher).to eq publisher
  end

  it 'whitelists mass-assignable attributes' do
    expect(Subscription.allowed_columns.sort).to eq [:geom, :publisher_id, :channel, :webhook_url, :phone_number, :email_address].sort
  end

  it 'round trip a geojson geometry through a postgis geometry column' do
    geojson = '{"type":"LineString","coordinates":[[102.0,0.0],[103.0,1.0],[104.0,0.0],[105.0,1.0]]}'
    subscription_id = create(:subscription, geom: geojson).id
    subscription = Subscription.first!(id: subscription_id)
    expect(subscription.geom).to eq geojson
  end

  it 'requires a valid GeoJSON feature geometry' do
    subscription = build(:subscription, geom: '{"type":"Feature","coordinates":[[[100.0,0.0],[101.0,0.0],[101.0,1.0],[100.0,1.0],[100.0,0.0]]]}')
    expect(subscription).not_to be_valid
  end

  it 'requires an available channel' do
    subscription = build(:subscription, channel: 'missing')
    expect(subscription).not_to be_valid
  end

  describe 'contact channel validations' do
    context 'webhook' do
      it 'requires the contact to be a valid url' do
        subscription = build(:subscription, channel: 'webhook', webhook_url: Faker::Internet.email)
        expect(subscription).not_to be_valid
      end
    end

    context 'sms' do
      it 'requires the contact to be a valid phone number', pending: 'best way to validate phone numbers?' do
        subscription = build(:subscription, channel: 'sms', phone_number: '555-5555')
        expect(subscription).not_to be_valid
      end
    end

    context 'email' do
      it 'requires the contact to be a valid email address' do
        subscription = build(:subscription, channel: 'email', email_address: Faker::PhoneNumber.short_phone_number)
        expect(subscription).not_to be_valid
      end
    end
  end
end
