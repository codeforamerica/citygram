require 'spec_helper'

describe Georelevent::Models::Event do
  it 'belongs to a publisher' do
    publisher = create(:publisher)
    event = create(:event, publisher: publisher).reload
    expect(event.publisher).to eq publisher
  end

  it 'whitelists mass-assignable attributes' do
    expect(Event.allowed_columns).to eq [:title, :description, :geom]
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
end
