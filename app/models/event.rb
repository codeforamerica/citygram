module Citygram::Models
  class Event < Sequel::Model
    many_to_one :publisher

    plugin :serialization, :geojson, :geom
    plugin :serialization, :pg_json, :properties
    plugin :geometry_validation

    dataset_module do
      def from_subscription(subscription, params = {})
        geom = GeoRuby::GeojsonParser.new.parse(subscription.geom).as_ewkt
        params[:publisher_id] = subscription.publisher_id
        from_geom(geom, params)
      end

      def from_geom(geom_ewkt, params)
        after_date = params[:after_date] || 7.days.ago
        before_date = params[:before_date] || DateTime.now

        with_sql(<<-SQL, params.fetch(:publisher_id), after_date, before_date, geom_ewkt).all
          SELECT events.*
          FROM events
          WHERE events.publisher_id = ?
            AND events.created_at > ?
            AND events.created_at <= ?
            AND ST_Intersects(events.geom, ?::geometry)
          ORDER BY events.created_at DESC
        SQL
      end
    end

    def validate
      super
      validates_presence [:title, :geom, :feature_id]
      validates_geometry :geom
      validates_unique [:publisher_id, :feature_id]
    end
  end
end
