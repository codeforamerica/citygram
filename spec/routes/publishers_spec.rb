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
    let(:geometry) { '{"type":"Polygon","coordinates":[[[-80.93490600585938,35.263561862152095],[-80.69320678710938,35.32745068492882],[-80.60531616210938,35.14124815600257],[-80.83328247070312,35.06597313798418],[-80.93490600585938,35.263561862152095]]]}' }
    let(:since) { 7.days.ago.iso8601 }
    let(:publisher) { create(:publisher) }

    it 'counts events by the publisher since a given date, intersecting a given geometry' do
      create(:event, publisher_id: publisher.id, geom: '{"type":"Point","coordinates":[0.0,0.0]}')
      create(:event, publisher_id: publisher.id, created_at: 2.weeks.ago, geom: '{"type":"Point","coordinates":[-80.898822,35.22454]}')

      create(:event, publisher_id: publisher.id, geom: '{"type":"Point","coordinates":[-80.898822,35.22454]}')
      create(:event, publisher_id: publisher.id, created_at: 2.weeks.ago, geom: '{"type":"Point","coordinates":[0.0,0.0]}')

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
