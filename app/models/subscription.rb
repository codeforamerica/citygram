module Georelevent
  module Models
    class Subscription < Sequel::Model
      plugin :serialization, :geojson, :geom
      set_allowed_columns :geom
    end
  end
end
