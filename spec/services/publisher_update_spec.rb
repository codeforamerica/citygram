require 'spec_helper'
require 'app/services/publisher_update'

describe Citygram::Services::PublisherUpdate do
  let(:features) { feature_collection['features'] }
  let(:feature_collection) { JSON.parse(fixture('cmpd-traffic-incidents.geojson')) }
  let(:publisher) { create(:publisher) }

  it 'creates event records for each feature' do
    expect{ Citygram::Services::PublisherUpdate.call(features, publisher) }.to change{ Event.where(publisher_id: publisher.id).count }.by(+4)
  end

  it 'returns the new event records' do
    events = Citygram::Services::PublisherUpdate.call(features, publisher)
    expect(events.count).to eq 4
    events.each do |event|
      expect(event.id).to be_present
      expect(event.class).to eq Event
    end
  end

  it 'sets the publisher_id' do
    events = Citygram::Services::PublisherUpdate.call(features, publisher)
    publisher_ids = events.map(&:publisher_id)
    expect(publisher_ids).to eq Array.new(4){ publisher.id }
  end

  it 'sets the feature_id' do
    events = Citygram::Services::PublisherUpdate.call(features, publisher)
    feature_ids = events.map(&:feature_id)
    expect(feature_ids).to eq [
      'CO0524171402',
      'O0524195903',
      'O0524195801',
      'CO0524142503'
    ]
  end

  it 'sets the title' do
    events = Citygram::Services::PublisherUpdate.call(features, publisher)
    titles = events.map(&:title)
    expect(titles).to eq [
      'CLOSED: ACCIDENT IN ROADWAY-PROPERTY DAMAGE at WILKINSON BV & PRUITT ST',
      'CARELESS/RECKLESS DRIVING at SHAMROCK DR & N SHARON AMITY RD',
      'ACCIDENT IN ROADWAY-PROPERTY DAMAGE at VILLAGE LAKE DR & MONROE RD',
      'CLOSED: ACCIDENT IN ROADWAY-PROPERTY DAMAGE at BALLANTYNE VILLAGE WY & JOHNSTON RD'
    ]
  end

  it 'sets the geometry' do
    events = Citygram::Services::PublisherUpdate.call(features, publisher)
    geoms = events.map(&:geom)
    expect(geoms).to eq [
      '{"type":"Point","coordinates":[-80.898822,35.22454]}',
      '{"type":"Point","coordinates":[-80.747266,35.226623]}',
      '{"type":"Point","coordinates":[-80.749406,35.157557]}',
      '{"type":"Point","coordinates":[-80.849765,35.052173]}'
    ]
  end

  it 'queues notification jobs for each new event' do
    clt_area = '{"type":"Polygon","coordinates":[[[-80.93490600585938,35.263561862152095],[-80.69320678710938,35.32745068492882],[-80.60531616210938,35.14124815600257],[-80.83328247070312,35.06597313798418],[-80.93490600585938,35.263561862152095]]]}'
    subscription = create(:subscription, publisher_id: publisher.id, geom: clt_area)

    expect{ Citygram::Services::PublisherUpdate.call(features, publisher) }.
      to change{ Citygram::Workers::Notifier.jobs.count }.by(+3)
  end
end
