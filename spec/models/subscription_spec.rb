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
    geojson = fixture('subject-geom.geojson')
    subscription_id = create(:subscription, geom: geojson).id
    subscription = Subscription.first!(id: subscription_id)
    expect(subscription.geom).to eq geojson
  end

  it 'requires a valid GeoJSON feature geometry' do
    subscription = build(:subscription, geom: fixture('invalid-geom.geojson'))
    expect(subscription).not_to be_valid
  end

  it 'requires an available channel' do
    subscription = build(:subscription, channel: 'missing')
    expect(subscription).not_to be_valid
  end

  it 'includes notifiables that are not unsubscribed' do
    subscription = create(:subscription, unsubscribed_at: nil)
    expect(Subscription.notifiables.all).to eq [subscription]
  end

  it 'excludes notifiables that are unsubscribed' do
    subscription = create(:subscription, unsubscribed_at: Date.today)
    expect(Subscription.notifiables.all).to be_empty
  end

  it 'includes notifiables with active publishers' do
    publisher = create(:publisher, active: true)
    subscription = create(:subscription, publisher: publisher).reload
    expect(Subscription.notifiables.all).to eq [subscription]
  end

  it 'excludes notifiables with inactive publishers' do
    publisher = create(:publisher, active: false)
    create(:subscription, publisher: publisher)
    expect(Subscription.notifiables.all).to be_empty
  end

  describe 'contact channel validations' do
    context 'webhook' do
      it 'requires the contact to be a valid url' do
        subscription = build(:subscription, channel: 'webhook', webhook_url: 'human@example.com')
        expect(subscription).not_to be_valid
      end
    end

    context 'sms' do
      it 'requires the contact to be a valid phone number' do
        subscription = build(:subscription, channel: 'sms', phone_number: '555-5555')
        expect(subscription).not_to be_valid
      end
    end

    context 'email' do
      it 'requires the contact to be a valid email address' do
        subscription = build(:subscription, channel: 'email', email_address: '+16024100680')
        expect(subscription).not_to be_valid
      end
    end
  end
end
