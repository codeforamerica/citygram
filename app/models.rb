require 'geo_ruby/geojson'
require 'phone'

# commom model config
Sequel.default_timezone = :utc
Sequel::Model.raise_on_save_failure = false
Sequel::Model.db.extension :pagination
Sequel::Model.plugin :attributes_helpers
Sequel::Model.plugin :json_serializer
Sequel::Model.plugin :save_helpers
Sequel::Model.plugin :serialization
Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :validation_helpers

# round trip a geojson geometry through a postgis geometry column
Sequel::Plugins::Serialization.register_format(:geojson,
  # transform a geojson geometry into extended well-known text format
  ->(v){ GeoRuby::GeojsonParser.new.parse(v).as_ewkt },
  # transform extended well-known binary into a geojson geometry
  ->(v){ GeoRuby::SimpleFeatures::Geometry.from_hex_ewkb(v).to_json }
)

# set default to US for now
Phoner::Phone.default_country_code = '1'

Sequel::Plugins::Serialization.register_format(:phone,
  ->(v){ Phoner::Phone.parse(v).to_s },
  ->(v){ v } # identity
)

module Citygram
  module Models
  end
end

require 'app/models/event'
require 'app/models/publisher'
require 'app/models/subscription'
