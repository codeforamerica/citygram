module Citygram::Models
  class Event < Sequel::Model
    many_to_one :publisher

    plugin :serialization, :geojson, :geom
    plugin :serialization, :json, :properties
    plugin :geometry_validation

    def self.from_geom(geom_ewkt, params)
      after_date = params[:after_date] || 7.days.ago
      before_date = params[:before_date] || 2.days.from_now
      dataset.with_sql(<<-SQL, params[:publisher_id], after_date, before_date, geom_ewkt).all
        SELECT events.geom, events.title
        FROM events
        WHERE events.publisher_id = ?
          AND events.created_at > ?
          AND events.created_at <= ?
          AND ST_Intersects(events.geom, ?::geometry)
        ORDER BY events.created_at DESC
      SQL
    end

    def validate
      super
      validates_presence [:title, :geom, :feature_id]
      validates_geometry :geom
      validates_unique [:publisher_id, :feature_id]
    end
  end
end
