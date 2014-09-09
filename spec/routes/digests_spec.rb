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
      subscription = create(:subscription, publisher: publisher, geom: FixtureHelpers::POINT_IN_POLYGON.polygon)
      event = create(:event, publisher: publisher, geom: FixtureHelpers::POINT_IN_POLYGON.point)

      get "/digests/#{subscription.id}/events"
      expect(last_response.body).to match(event.title)
    end
  end
end
