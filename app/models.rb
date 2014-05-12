require 'lib/sequel/geometry_serializer'
require 'lib/sequel/save_helpers'

Sequel.default_timezone = :utc

Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :serialization
Sequel::Model.plugin Sequel::Plugins::SaveHelpers

Sequel::Plugins::Serialization.register_format(:geometry,
  Georelevent::InboundGeom.new,
  Georelevent::OutboundGeom.new
)

module Georelevent
  module Models
  end
end

require 'app/models/event'
require 'app/models/subscription'
