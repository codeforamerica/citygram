require 'geo_ruby/geojson'
require 'app/models/plugins/attributes_helpers'
require 'app/models/plugins/geometry_validation_helpers'
require 'app/models/plugins/save_helpers'
require 'app/models/plugins/url_validation_helpers'
require 'app/models/plugins/intersection_query_methods'
require 'app/services/connection_builder'

Sequel.default_timezone = :utc

Sequel::Model.raise_on_save_failure = false

Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :serialization
Sequel::Model.plugin :json_serializer
Sequel::Model.plugin :validation_helpers

# enable pagination
Sequel::Model.db.extension :pagination

# round trip a geojson geometry through a postgis geometry column
Sequel::Plugins::Serialization.register_format(:geojson,
  # transform a geojson geometry into extended well-known text format
  ->(v){ GeoRuby::GeojsonParser.new.parse(v).as_ewkt },
  # transform extended well-known binary into a geojson geometry
  ->(v){ GeoRuby::SimpleFeatures::Geometry.from_hex_ewkb(v).to_json }
)

module Citygram
  module Models
  end
end

require 'app/models/event'
require 'app/models/publisher'
require 'app/models/subscription'
