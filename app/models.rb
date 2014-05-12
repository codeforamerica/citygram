require 'geo_ruby/geojson'
require 'lib/sequel/save_helpers'

Sequel.default_timezone = :utc

Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :serialization
Sequel::Model.plugin :json_serializer
Sequel::Model.plugin Sequel::Plugins::SaveHelpers

# round trip a geojson geometry through a postgis geometry column
Sequel::Plugins::Serialization.register_format(:geojson,
  # transform a geojson geometry into extended well-known text format
  ->(v){ GeoRuby::GeojsonParser.new.parse(v).as_ewkt },
  # transform extended well-known binary into a geojson geometry
  ->(v){ GeoRuby::SimpleFeatures::Geometry.from_hex_ewkb(v).to_json }
)

module Georelevent
  module Models
  end
end

require 'app/models/event'
require 'app/models/publisher'
require 'app/models/subscription'
