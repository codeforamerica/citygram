require 'spec_helper'

describe Citygram::Routes::Digests do
  include Citygram::Routes::TestHelpers

  describe 'GET /digests' do
    let(:included_point) { '{"type":"Point","coordinates":[100.5,20.5]}' }
    let(:polygon){'{"type":"Polygon","coordinates":[[[100.0,20.0],[101.0,20.0],[101.0,21.0],[100.0,21.0],[100.0,20.0]]]}'}

    it 'displays an event created after a given date' do
      publisher = create(:publisher)
      perfect = create(:event, publisher: publisher, created_at: 1.day.ago, geom: included_point)
      too_old = create(:event, publisher: publisher, created_at: 3.days.ago, geom: included_point)

      get "/digests", publisher_id: publisher.id, after_date: 2.days.ago, geometry: polygon
      expect(last_response.body).to match(perfect.title)
      expect(last_response.body).to_not match(too_old.title)
    end
  end
end
