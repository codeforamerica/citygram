require 'spec_helper'

describe Georelevent::Workers::PublisherPoll do
  subject { Georelevent::Workers::PublisherPoll.new }
  let(:publisher) { create(:publisher) }
  let(:features) { JSON.parse(geojson)['features'] }
  let(:geojson) { fixture('cmpd-traffic-incidents.geojson') }

  before do
    stub_request(:get, publisher.endpoint).
      with(headers: {'Content-Type'=>'application/json'}).
      to_return(status: 200, body: geojson)
  end

  it 'retrieves the latest events from the publishers endpoint' do
    subject.perform(publisher.id)
    expect(a_request(:get, publisher.endpoint)).to have_been_made
  end

  it 'passes the retrieved features to PublisherUpdate' do
    expect(Georelevent::Services::PublisherUpdate).to receive(:call).with(features, publisher)
    subject.perform(publisher.id)
  end
end
