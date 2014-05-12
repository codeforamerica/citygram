module Georelevent
  module Models
    class Event < Sequel::Model
      plugin :serialization, :geometry, :geom
    end
  end 
end
