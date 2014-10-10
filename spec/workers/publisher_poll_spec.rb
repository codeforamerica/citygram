require 'spec_helper'

describe Citygram::Workers::PublisherPoll do
  subject { Citygram::Workers::PublisherPoll.new }
  let(:publisher) { create(:publisher) }
  let(:features) { JSON.parse(body)['features'] }
  let(:body) { fixture('cmpd-traffic-incidents.geojson') }
  let(:new_events) { double('new events', any?: true) }

  describe '#perform' do
    before do
      stub_request(:get, publisher.endpoint).
        with(headers: {'Accept'=>'application/json'}).
        to_return(status: 200, body: body)
    end

    it 'retrieves the latest events from the publishers endpoint' do
      subject.perform(publisher.id, publisher.endpoint)
      expect(a_request(:get, publisher.endpoint)).to have_been_made
    end

    it 'passes the retrieved features to PublisherUpdate' do
      expect(Citygram::Services::PublisherUpdate).
        to receive(:call).with(features, publisher).and_return(new_events)
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
        with(headers: { 'Accept' => 'application/json' }).
        to_return(status: 200, headers: { 'Next-Page' => next_page }, body: body)
    end

    context 'success' do
      it 'retrieves the latest events from the publishers endpoint' do
        subject.perform(publisher.id, publisher.endpoint)
        expect(a_request(:get, publisher.endpoint)).to have_been_made
      end

      it 'passes the retrieved features to PublisherUpdate' do
        expect(Citygram::Services::PublisherUpdate).
          to receive(:call).with(features, publisher).and_return(new_events)
        subject.perform(publisher.id, publisher.endpoint)
      end

      it 'creates a publisher poll job for the next page' do
        expect {
          subject.perform(publisher.id, publisher.endpoint)
        }.to change{ Citygram::Workers::PublisherPoll.jobs.count }.by(+1)

        last_job = Citygram::Workers::PublisherPoll.jobs.last
        expect(last_job['args']).to eq [publisher.id, next_page, 2]
      end
    end

    context 'failure' do
      context 'empty header value' do
        let(:next_page) { ' ' }

        it 'does not create a new publisher poll job' do
          expect {
            subject.perform(publisher.id, publisher.endpoint)
          }.not_to change{ Citygram::Workers::PublisherPoll.jobs.count }
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
          expect {
            subject.perform(publisher.id, publisher.endpoint)
          }.not_to change{ Citygram::Workers::PublisherPoll.jobs.count }
        end
      end

      context 'max page number reached' do
        it 'does not create a new publisher poll job' do
          expect {
            subject.perform(publisher.id, publisher.endpoint, Citygram::Workers::PublisherPoll::MAX_PAGE_NUMBER)
          }.not_to change{ Citygram::Workers::PublisherPoll.jobs.count }
        end
      end

      context 'no new records returned' do
        let(:body) { fixture('empty-feature-collection.geojson') }

        it 'does not create a new publisher poll job' do
          expect {
            subject.perform(publisher.id, publisher.endpoint)
          }.not_to change{ Citygram::Workers::PublisherPoll.jobs.count }
        end
      end
    end
  end

  it 'limits the number of retries' do
    retries = Citygram::Workers::PublisherPoll.sidekiq_options_hash["retry"]
    expect(retries).to eq 5
  end
end
