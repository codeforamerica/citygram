require 'spec_helper'

describe Citygram::Routes::Events do
  include Citygram::Routes::TestHelpers

  describe 'GET subscriptions/:id/events' do
    it 'returns events for a given description' do
      publisher = create(:publisher)
      events = create_list(:event, 2, publisher: publisher, geom: FixtureHelpers::POINT_IN_POLYGON.point)
      create(:event, publisher: publisher, geom: FixtureHelpers::POINT_IN_POLYGON.excluded_point)

      get "/publishers/#{publisher.id}/events", geometry: FixtureHelpers::POINT_IN_POLYGON.polygon
      expect(last_response.body).to eq [
        { geom: events[1].geom, title: events[1].title },
        { geom: events[0].geom, title: events[0].title }
      ].to_json
    end
  end
end
