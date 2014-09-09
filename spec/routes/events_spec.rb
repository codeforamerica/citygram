require 'spec_helper'

describe Citygram::Routes::Events do
  include Citygram::Routes::TestHelpers

  describe 'GET subscriptions/:id/events' do
    let(:included_point) { '{"type":"Point","coordinates":[-80.898822,35.22454]}' }
    let(:polygon) { '{"type":"Polygon","coordinates":[[[-80.93490600585938,35.263561862152095],[-80.69320678710938,35.32745068492882],[-80.60531616210938,35.14124815600257],[-80.83328247070312,35.06597313798418],[-80.93490600585938,35.263561862152095]]]}' }

    it 'returns events for a given description' do
      publisher = create(:publisher)
      events = create_list(:event, 2, publisher: publisher, geom: included_point)
      create(:event, publisher: publisher, geom: '{"type":"Point","coordinates":[0.0,0.0]}')

      get "/publishers/#{publisher.id}/events", geometry: polygon
      expect(last_response.body).to eq [
        { geom: events[1].geom, title: events[1].title },
        { geom: events[0].geom, title: events[0].title }
      ].to_json
    end

    it 'returns events created after a given date' do
      publisher = create(:publisher)
      perfect = create(:event, publisher: publisher, created_at: 1.day.ago, geom: included_point)
      too_old = create(:event, publisher: publisher, created_at: 3.days.ago, geom: included_point)

      get "/publishers/#{publisher.id}/events", after_date: 2.days.ago, geometry: polygon
      expect(last_response.body).to eq [
        { geom: perfect.geom, title: perfect.title }
      ].to_json
    end

    it 'returns events created before a given date' do
      publisher = create(:publisher)
      too_new = create(:event, publisher: publisher, created_at: 1.day.ago, geom: included_point)
      perfect = create(:event, publisher: publisher, created_at: 3.days.ago, geom: included_point)

      get "/publishers/#{publisher.id}/events", before_date: 2.days.ago, geometry: polygon
      expect(last_response.body).to eq [
        { geom: perfect.geom, title: perfect.title }
      ].to_json
    end
  end
end
