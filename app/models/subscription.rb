module Citygram
  module Models
    class Subscription < Sequel::Model
      many_to_one :publisher

      plugin :serialization, :geojson, :geom
      plugin Citygram::Models::Plugins::GeometryValidationHelpers
      set_allowed_columns :endpoint, :geom, :publisher_id

      def connection
        Citygram::Services::ConnectionBuilder.json("request.subscription.#{id}", url: endpoint)
      end

      def validate
        super
        validates_presence [:geom, :endpoint, :publisher_id]
        validates_geometry :geom
      end
    end
  end
end
