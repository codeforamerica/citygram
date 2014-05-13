module Georelevent
  module Models
    class Subscription < Sequel::Model
      plugin :serialization, :geojson, :geom
      set_allowed_columns :geom

      def validate
        super
        validates_presence [:geom]
        validates_geometry :geom
      end
    end
  end
end
