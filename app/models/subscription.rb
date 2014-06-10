module Georelevent
  module Models
    class Subscription < Sequel::Model
      many_to_one :publisher

      plugin :serialization, :geojson, :geom
      set_allowed_columns :endpoint, :geom

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
