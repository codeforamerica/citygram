module Georelevent
  module Models
    class Event < Sequel::Model
      plugin :serialization, :geojson, :geom
      set_allowed_columns :title, :description, :geom

      def validate
        super
        validates_presence [:geom]
        validates_geometry :geom
      end
    end
  end 
end
