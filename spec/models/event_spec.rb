require 'spec_helper'

describe Citygram::Models::Event do
  it 'belongs to a publisher' do
    type = Event.association_reflections[:publisher][:type]
    expect(type).to eq :many_to_one
  end

  it 'whitelists mass-assignable attributes' do
    expect(Event.allowed_columns).to eq []
  end

  it 'round trip a geojson geometry through a postgis geometry column' do
    geometry = '{"type":"Polygon","coordinates":[[[100.0,0.0],[101.0,0.0],[101.0,1.0],[100.0,1.0],[100.0,0.0]]]}'
    event_id = create(:event, geom: geometry).id
    event = Event.first!(id: event_id)
    expect(event.geom).to eq geometry
  end

  it 'requires a title' do
    event = build(:event, title: '')
    expect(event).not_to be_valid
  end

  it 'requires a valid GeoJSON feature geometry' do
    event = build(:event, geom: '{"type":"Feature","coordinates":[[[100.0,0.0],[101.0,0.0],[101.0,1.0],[100.0,1.0],[100.0,0.0]]]}')
    expect(event).not_to be_valid
  end

  it 'requires a feature_id' do
    event = build(:event, feature_id: '')
    expect(event).not_to be_valid
  end

  it 'requires a unique publisher_id/feature_id combination' do
    feature_id = 'abc123'
    publisher = create(:publisher)
    event = create(:event, publisher_id: publisher.id, feature_id: feature_id)
    duplicate = build(:event, publisher_id: publisher.id, feature_id: feature_id)
    expect(duplicate).not_to be_valid
  end

  it 'performs an intersection query on a given GeoJSON geometry' do
    clt_area1 = '{"type":"Polygon","coordinates":[[[-80.93490600585938,35.263561862152095],[-80.69320678710938,35.32745068492882],[-80.60531616210938,35.14124815600257],[-80.83328247070312,35.06597313798418],[-80.93490600585938,35.263561862152095]]]}'
    clt_area2 = '{"type":"Polygon","coordinates":[[[-81.01043701171875,35.28710571680812],[-80.78933715820311,35.27141057410734],[-80.94589233398438,35.144055579796344],[-81.01043701171875,35.28710571680812]]]}'
    nyc_area = '{"type":"Polygon","coordinates":[[[-74.11102294921875,40.875103022165824],[-73.85833740234374,40.90313381465847],[-73.81027221679688,40.74621655456364],[-74.00665283203124,40.65563874006115],[-74.0972900390625,40.70562793820592],[-74.11102294921875,40.875103022165824]]]}'
    event1 = create(:event, geom: clt_area1)
    event2 = create(:event, geom: nyc_area)

    intersecting = Event.intersecting(clt_area2).all
    expect(intersecting).to eq [event1]
  end
end
