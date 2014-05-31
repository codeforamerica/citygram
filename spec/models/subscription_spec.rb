require 'spec_helper'

describe Georelevent::Models::Subscription do
  it 'belongs to a publisher' do
    publisher = create(:publisher)
    subscription = create(:subscription, publisher: publisher).reload 
    expect(subscription.publisher).to eq publisher
  end

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

  it 'performs an intersection query on a given GeoJSON geometry' do
    clt_area1 = '{"type":"Polygon","coordinates":[[[-80.93490600585938,35.263561862152095],[-80.69320678710938,35.32745068492882],[-80.60531616210938,35.14124815600257],[-80.83328247070312,35.06597313798418],[-80.93490600585938,35.263561862152095]]]}'
    clt_area2 = '{"type":"Polygon","coordinates":[[[-81.01043701171875,35.28710571680812],[-80.78933715820311,35.27141057410734],[-80.94589233398438,35.144055579796344],[-81.01043701171875,35.28710571680812]]]}'
    nyc_area = '{"type":"Polygon","coordinates":[[[-74.11102294921875,40.875103022165824],[-73.85833740234374,40.90313381465847],[-73.81027221679688,40.74621655456364],[-74.00665283203124,40.65563874006115],[-74.0972900390625,40.70562793820592],[-74.11102294921875,40.875103022165824]]]}'
    sub1 = create(:subscription, geom: clt_area1)
    sub2 = create(:subscription, geom: nyc_area)

    intersecting = Subscription.intersecting(clt_area2).all
    expect(intersecting).to eq [sub1]
  end
end
