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

  describe '#perform with pagination' do
    let(:next_page) do
      url = URI(publisher.endpoint)
      params = Faraday::Utils.parse_query(url.query) || {}
      query  = Faraday::Utils.build_query(params.merge('page' => 2, 'per_page' => 1000))
      url.query = query
      url.to_s
    end

    before do
      stub_request(:get, publisher.endpoint).
        with(headers: { 'Content-Type' => 'application/json' }).
        to_return(status: 200, headers: { 'Next-Page' => next_page }, body: geojson)
    end

    context 'success' do
      it 'retrieves the latest events from the publishers endpoint' do
        subject.perform(publisher.id, publisher.endpoint)
        expect(a_request(:get, publisher.endpoint)).to have_been_made
      end

      it 'passes the retrieved features to PublisherUpdate' do
        expect(Citygram::Services::PublisherUpdate).to receive(:call).with(features, publisher)
        subject.perform(publisher.id, publisher.endpoint)
      end

      it 'creates a publisher poll job for the next page' do
        expect(Citygram::Workers::PublisherPoll).to receive(:perform_async).with(publisher.id, next_page, 2)
        subject.perform(publisher.id, publisher.endpoint)
      end
    end

    context 'failure' do
      context 'empty header value' do
        let(:next_page) { ' ' }

        it 'does not create a new publisher poll job' do
          expect(Citygram::Workers::PublisherPoll).not_to receive(:perform_async).with(publisher.id, next_page)
          subject.perform(publisher.id, publisher.endpoint)
        end
      end

      context 'different host' do
        let(:next_page) do
          url = URI(publisher.endpoint)
          params = Faraday::Utils.parse_query(url.query) || {}
          query  = Faraday::Utils.build_query(params.merge('page' => 2, 'per_page' => 1000))
          url.query = query

          url.host = 'danger-hackz.com'

          url.to_s
        end

        it 'does not create a new publisher poll job' do
          expect(Citygram::Workers::PublisherPoll).not_to receive(:perform_async).with(publisher.id, next_page)
          subject.perform(publisher.id, publisher.endpoint)
        end
      end

      context 'max page number reached' do
        it 'does not create a new publisher poll job' do
          expect(Citygram::Workers::PublisherPoll).not_to receive(:perform_async).with(publisher.id, next_page)
          subject.perform(publisher.id, publisher.endpoint, Citygram::Workers::PublisherPoll::MAX_PAGE_NUMBER)
        end
      end
    end
  end

  it 'limits the number of retries' do
    retries = Citygram::Workers::PublisherPoll.sidekiq_options_hash["retry"]
    expect(retries).to eq 5
  end
end
