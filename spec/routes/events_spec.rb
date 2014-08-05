require 'spec_helper'

describe Citygram::Routes::Events do
  include Citygram::Routes::TestHelpers

  describe 'GET subscriptions/:id/events' do
    it 'returns events for a given description' do
      publisher = create(:publisher)
      events = create_list(:event, 2, publisher: publisher, geom: '{"type":"Point","coordinates":[-80.898822,35.22454]}')
      create(:event, publisher: publisher, geom: '{"type":"Point","coordinates":[0.0,0.0]}')

      get "/publishers/#{publisher.id}/events", geometry: '{"type":"Polygon","coordinates":[[[-80.93490600585938,35.263561862152095],[-80.69320678710938,35.32745068492882],[-80.60531616210938,35.14124815600257],[-80.83328247070312,35.06597313798418],[-80.93490600585938,35.263561862152095]]]}'

      expect(last_response.body).to eq [events[1], events[0]].to_json
    end
  end
end
