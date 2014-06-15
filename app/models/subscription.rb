module Citygram
  module Models
    class Subscription < Sequel::Model
      many_to_one :publisher

      plugin :serialization, :geojson, :geom
      set_allowed_columns :endpoint, :geom

      dataset_module do
        def for_event(event)
          where(publisher_id: event.publisher_id).intersecting(event.geom)
        end
      end

      def connection
        ConnectionBuilder.json("request.subscription.#{id}", url: endpoint)
      end

      def validate
        super
        validates_presence [:geom]
        validates_geometry :geom
      end
    end
  end
end
