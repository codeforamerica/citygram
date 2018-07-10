module Citygram::Routes
  class Publishers < Grape::API
    version 'v1', using: :header, vendor: 'citygram'
    format :json

    rescue_from Sequel::NoMatchingRow do
      Rack::Response.new({error: 'not found'}.to_json, 404)
    end

    desc 'Retrieve a list of publishers'

    params do
      optional :page, type: Integer, default: 1
      optional :per, type: Integer, default: 10, max: 1000
      optional :tag, type: String
    end

    get '/publishers' do
      Publisher.dataset.yield_self do |publishers|
        params[:tag] ? publishers.tagged(params[:tag]) : publishers
      end.paginate(params[:page], params[:per]).order(Sequel.desc(:created_at))
    end

    desc <<-DESC
      Count of events by a given publisher
    DESC

    params do
      requires :publisher_id, type: Integer
      optional :geometry, type: String
      optional :since, type: DateTime
    end

    get '/publishers/:publisher_id/events_count' do
      query = Event.where(publisher_id: params[:publisher_id])
      
      if since = params[:since]
        query = query.where('created_at > ?', since)
      end

      if geometry = params[:geometry]
        geom = GeoRuby::GeojsonParser.new.parse(geometry)
        query = query.where('ST_Intersects(geom, ?::geometry)', geom.as_ewkt)
      end

      {
        events_count: query.count,
        publisher_id: params[:publisher_id],
        geometry: geometry,
        since: since,
      }
    end
  end
end
