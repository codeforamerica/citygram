module Georelevent
  module Models
    class Event < Sequel::Model
      plugin :serialization, :geojson, :geom
      set_allowed_columns :title, :description, :geom
    end
  end 
end
