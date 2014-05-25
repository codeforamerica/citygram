require 'spec_helper'
require 'app/workers/publisher_update'

describe Georelevent::Workers::PublisherUpdate do
  subject { Georelevent::Workers::PublisherUpdate.new(features, publisher) }
  let(:features) { feature_collection['features'] }
  let(:feature_collection) { JSON.parse(fixture('cmpd-traffic-incidents.geojson')) }
  let(:publisher) { create(:publisher) }

  it 'creates event records for each feature' do
    expect{ subject.call }.to change{ Event.where(publisher_id: publisher.id).count }.by(+4)
  end

  it 'returns the new event records' do
    events = subject.call
    feature_ids = events.map(&:feature_id)
    titles = events.map(&:title)
    geoms = events.map(&:geom)
    expect(feature_ids).to eq [
      'CO0524171402',
      'O0524195903',
      'O0524195801',
      'CO0524142503'
    ]
    expect(titles).to eq [
      'CLOSED: ACCIDENT IN ROADWAY-PROPERTY DAMAGE at WILKINSON BV & PRUITT ST',
      'CARELESS/RECKLESS DRIVING at SHAMROCK DR & N SHARON AMITY RD',
      'ACCIDENT IN ROADWAY-PROPERTY DAMAGE at VILLAGE LAKE DR & MONROE RD',
      'CLOSED: ACCIDENT IN ROADWAY-PROPERTY DAMAGE at BALLANTYNE VILLAGE WY & JOHNSTON RD'
    ]
    expect(geoms).to eq [
      '{"type":"Point","coordinates":[-80.898822,35.22454]}',
      '{"type":"Point","coordinates":[-80.747266,35.226623]}',
      '{"type":"Point","coordinates":[-80.749406,35.157557]}',
      '{"type":"Point","coordinates":[-80.849765,35.052173]}'
    ]
  end
end
