require 'geo_ruby/geojson'
require 'phone'
require 'sequel'

ENV['DATABASE_URL'] ||= "postgres://localhost/citygram_#{Citygram::App.environment}"
DB = Sequel.connect(ENV['DATABASE_URL'], max_connections: ENV.fetch('MAX_CONNECTIONS', 20))

Sequel.default_timezone = :utc

# no mass-assignable columns by default
Sequel::Model.set_allowed_columns(*[])

# use first!, create!, save! to raise
Sequel::Model.raise_on_save_failure = false

# sequel's standard pagination
DB.extension :pagination

DB.extension :pg_json, :pg_array

# common model plugins
Sequel::Model.plugin :attributes_helpers
Sequel::Model.plugin :json_serializer
Sequel::Model.plugin :save_helpers
Sequel::Model.plugin :serialization
Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :validation_helpers

Sequel::Plugins::Serialization.register_format(:pg_array,
  ->(v){ Sequel.pg_array(v) },
  ->(v){
    case v
    when Sequel::Postgres::PGArray
      v.to_a
    when String
      Sequel::Postgres::PGArray::Parser.new(v).parse
    else
      raise Sequel::InvalidValue, "invalid value for array: #{v.inspect}"
    end
  }
)

# roundtrip a `Hash` or `Array` through a native postgres json column
Sequel::Plugins::Serialization.register_format(:pg_json,
  ->(v){ Sequel.pg_json(v) },
  ->(v){
    # TODO: does sequel expose an interface for this case handling?
    case v
    when Sequel::Postgres::JSONHash
      v.to_h
    when Sequel::Postgres::JSONArray
      v.to_a
    when String
      Sequel.parse_json(v)
    else
      raise Sequel::InvalidValue, "invalid value for json: #{v.inspect}"
    end
  }
)

# round trip a geojson geometry through a postgis geometry column
Sequel::Plugins::Serialization.register_format(:geojson,
  # transform a geojson geometry into extended well-known text format
  ->(v){ GeoRuby::GeojsonParser.new.parse(v).as_ewkt },
  # transform extended well-known binary into a geojson geometry
  ->(v){ GeoRuby::SimpleFeatures::Geometry.from_hex_ewkb(v).to_json }
)

# set default to US for now
Phoner::Phone.default_country_code = '1'

# normalize phone numbers to E.164
Sequel::Plugins::Serialization.register_format(:phone,
  ->(v){ Phoner::Phone.parse(v).to_s },
  ->(v){ v } # identity
)

module Citygram
  module Models
  end
end

require 'app/models/city'
require 'app/models/event'
require 'app/models/publisher'
require 'app/models/subscription'

# access model class constants without qualifying namespace
include Citygram::Models
