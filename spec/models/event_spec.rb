require 'spec_helper'

describe Georelevent::Models::Event do
  it 'roundtrips geojson-structured data with postgis types' do
    polygon = {"type"=>"Polygon","coordinates"=>[[[100.0,0.0],[101.0,0.0],[101.0,1.0],[100.0,1.0],[100.0,0.0]]]}
    event_id = create(:event, geom: polygon).id
    event = Event.first!(id: event_id)
    expect(event.geom).to eq polygon
  end
end
