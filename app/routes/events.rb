module Citygram::Routes
  class Events < Grape::API
    version 'v1', using: :header, vendor: 'citygram'
    format :json

    rescue_from Sequel::NoMatchingRow do
      Rack::Response.new({error: 'not found'}.to_json, 404)
    end

    helpers do
      def hyperlink(str)
        # extract an array of urls
        urls = URI.extract(str).select do |url|
          # handle edge cases like `more:`, which is extracted as by URI.extract
          URI(url) rescue false
        end

        # create 'a' tags from urls
        # TODO: move this to a template and cleanup inline styling
        links = urls.map do |url|
          "<a href='#{url.gsub(/\.\z/, '')}' target='_blank'>#{url}</a>"
        end

        # swap in the html tag
        links.zip(urls).each do |link, url|
          str = str.gsub(url, link)
        end

        str
      end
    end

    desc <<-DESC
      Retrieve events from the last week for a publisher, intersecting a given geometry
    DESC

    params do
      requires :geometry, type: String
      requires :publisher_id, type: Integer
    end

    get 'publishers/:publisher_id/events' do
      geom = GeoRuby::GeojsonParser.new.parse(params[:geometry])
      after_date = params[:after_date] || 7.days.ago
      before_date = params[:before_date] || 2.days.from_now

      results = Event.dataset.with_sql(<<-SQL, params[:publisher_id], after_date, before_date, geom.as_ewkt).all
        SELECT events.geom, events.title
        FROM events
        WHERE events.publisher_id = ?
          AND events.created_at > ?
          AND events.created_at <= ?
          AND ST_Intersects(events.geom, ?::geometry)
        ORDER BY events.created_at DESC
      SQL

      results.map do |result|
        result[:title] = hyperlink(result[:title])
        result
      end
    end
  end
end
