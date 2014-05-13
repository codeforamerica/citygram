require 'spec_helper'

describe Georelevent::Models::Subscription do
  it 'whitelists mass-assignable attributes' do
    expect(Subscription.allowed_columns).to eq [:geom]
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
end
