module Citygram
  module Routes
    class Events < Grape::API
      version 'v1', using: :header, vendor: 'citygram'
      format :json

      rescue_from Sequel::NoMatchingRow do
        Rack::Response.new({error: 'not found'}.to_json, 404)
      end

      desc <<-DESC
        Retrieve events from the last 24 hours for a publisher, intersecting a given geometry
      DESC

      params do
        requires :geometry, type: String
        requires :publisher_id, type: Integer
      end

      get 'publishers/:publisher_id/events' do
        geom = GeoRuby::GeojsonParser.new.parse(params[:geometry])
        Event.dataset.with_sql(<<-SQL, params[:publisher_id], 24.hours.ago, geom.as_ewkt).all
          SELECT events.*
          FROM events
          WHERE events.publisher_id = ?
            AND events.created_at > ?
            AND ST_Intersects(events.geom, ?)
        SQL
      end
    end
  end
end
