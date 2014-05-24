module Georelevent
  module Models
    class Event < Sequel::Model
      many_to_one :publisher

      plugin :serialization, :geojson, :geom
      set_allowed_columns *[] # disallow mass-assignment

      def validate
        super
        validates_presence [:title, :geom]
        validates_geometry :geom
      end
    end
  end 
end
