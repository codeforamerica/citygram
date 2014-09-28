require 'spec_helper'

describe Citygram::Routes::Publishers do
  include Citygram::Routes::TestHelpers

  describe 'GET /publishers' do
    let(:params) {{ page: 2, per: 2 }}
    let!(:publishers) { create_list(:publisher, 5) }

    it 'responds with 200 OK' do
      get '/publishers', params
      expect(last_response.status).to eq 200
    end

    it 'returns the list of publishers' do
      get '/publishers', params
      expect(last_response.body).to eq [publishers[2], publishers[1]].to_json
    end
  end

  describe 'GET /publishers/:publisher_id/events_count' do
    let(:params) {{ since: since, geometry: geometry }}
    let(:geometry) { FixtureHelpers::POINT_IN_POLYGON.polygon }
    let(:since) { 7.days.ago.iso8601 }
    let(:publisher) { create(:publisher) }

    it 'counts events by the publisher since a given date, intersecting a given geometry' do
      create(:event, publisher_id: publisher.id, geom: FixtureHelpers::POINT_IN_POLYGON.point)
      create(:event, publisher_id: publisher.id, geom: FixtureHelpers::POINT_IN_POLYGON.excluded_point)

      create(:event, publisher_id: publisher.id, created_at: 2.weeks.ago, geom: FixtureHelpers::POINT_IN_POLYGON.point)
      create(:event, publisher_id: publisher.id, created_at: 2.weeks.ago, geom: FixtureHelpers::POINT_IN_POLYGON.excluded_point)

      get "/publishers/#{ publisher.id }/events_count", params

      resp = {
        events_count: 1,
        publisher_id: publisher.id,
        geometry: geometry,
        since: since,
      }

      expect(last_response.body).to eq resp.to_json
      expect(last_response.status).to eq 200
    end
  end
end
