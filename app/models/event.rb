require_relative '../../lib/geometry_serializer'

module Georelevent
  module Models
    class Event < Sequel::Model
      plugin :timestamps, update_on_create: true
      plugin :serialization
      serialize_attributes [Georelevent::InboundGeom.new, Georelevent::OutboundGeom.new], :geom
    end
  end 
end
