require 'geo_ruby/geojson'
require 'active_support/core_ext/hash/keys'

module Georelevent
  # serialize a parsed GeoJSON structure as extended well-known text format
  class InboundGeom
    def call(v)
      feature = GeoRuby::GeojsonParser.new.send(:parse_geohash, v, GeoRuby::SimpleFeatures::DEFAULT_SRID)
      feature.as_ewkt
    end
  end

  # deserialize extended well-known binary feature to a GeoJSON-structured Ruby hash
  class OutboundGeom
    def call(v)
      feature = GeoRuby::SimpleFeatures::Geometry.from_hex_ewkb(v)
      feature.as_json.stringify_keys
    end
  end
end
