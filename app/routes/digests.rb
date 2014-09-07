module Citygram::Routes
  class Digests < Citygram::App
    get '/digests' do
      geom = GeoRuby::GeojsonParser.new.parse(params[:geometry])
      after_date = params[:after_date] || 7.days.ago
      before_date = params[:before_date] || Date.tomorrow
      @dummy = params[:dummy]
      @results = Event.dataset.with_sql(<<-SQL, params[:publisher_id], after_date, before_date, geom.as_ewkt).all
        SELECT events.geom, events.title
        FROM events
        WHERE events.publisher_id = ?
          AND events.created_at > ?
          AND events.created_at <= ?
          AND ST_Intersects(events.geom, ?::geometry)
        ORDER BY events.created_at DESC
      SQL

      erb :digest
    end
  end
end
