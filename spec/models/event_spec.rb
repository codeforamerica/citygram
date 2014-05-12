require 'spec_helper'

describe Georelevent::Models::Event do
  it 'whitelists mass-assignable attributes' do
    expect(Event.allowed_columns).to eq [:title, :description, :geom]
  end

  it 'round trip a geojson geometry through a postgis geometry column' do
    geometry = '{"type":"Polygon","coordinates":[[[100.0,0.0],[101.0,0.0],[101.0,1.0],[100.0,1.0],[100.0,0.0]]]}'
    event_id = create(:event, geom: geometry).id
    event = Event.first!(id: event_id)
    expect(event.geom).to eq geometry
  end
end
