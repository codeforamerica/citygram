module Citygram::Routes
  class Digests < Citygram::App
    get '/digests/:subscription_id/events' do
      subscription = Subscription[params[:subscription_id]]
      geom = GeoRuby::GeojsonParser.new.parse(subscription.geom).as_ewkt

      after_date = params[:after_date] || 7.days.ago
      before_date = params[:before_date] || 2.days.from_now

      @results = Event.dataset.with_sql(<<-SQL, subscription.publisher_id, after_date, before_date, geom).all
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
