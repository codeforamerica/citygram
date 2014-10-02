require 'spec_helper'

describe Citygram::Workers::PublisherPoll do
  subject { Citygram::Workers::PublisherPoll.new }
  let(:publisher) { create(:publisher) }
  let(:features) { JSON.parse(geojson)['features'] }
  let(:geojson) { fixture('cmpd-traffic-incidents.geojson') }

  describe '#perform' do
    before do
      stub_request(:get, publisher.endpoint).
        with(headers: {'Content-Type'=>'application/json'}).
        to_return(status: 200, body: geojson)
    end

    it 'retrieves the latest events from the publishers endpoint' do
      subject.perform(publisher.id, publisher.endpoint)
      expect(a_request(:get, publisher.endpoint)).to have_been_made
    end

    it 'passes the retrieved features to PublisherUpdate' do
      expect(Citygram::Services::PublisherUpdate).to receive(:call).with(features, publisher)
      subject.perform(publisher.id, publisher.endpoint)
    end
  end

  it 'limits the number of retries' do
    retries = Citygram::Workers::PublisherPoll.sidekiq_options_hash["retry"]
    expect(retries).to eq 5
  end
end
