require 'spec_helper'

describe Citygram::Routes::Digests do
  include Citygram::Routes::TestHelpers

  describe 'GET /digests/:subscription_id/events' do
    it 'responds with 200' do
      subscription = create(:subscription)
      get "/digests/#{subscription.id}/events"
      expect(last_response.status).to eq 200
    end

    it 'shows digest of events' do
      publisher = create(:publisher)
      polygon = '{"type":"Polygon","coordinates":[[[100.0,20.0],[101.0,20.0],[101.0,21.0],[100.0,21.0],[100.0,20.0]]]}'
      included_point = '{"type":"Point","coordinates":[100.5,20.5]}'

      subscription = create(:subscription, publisher: publisher, geom: polygon)
      event = create(:event, publisher: publisher, geom: included_point)

      get "/digests/#{subscription.id}/events"
      expect(last_response.body).to match(event.title)
    end
  end
end
