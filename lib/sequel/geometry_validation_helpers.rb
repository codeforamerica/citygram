require 'geo_ruby/geojson'

module Sequel
  module Plugins
    module GeometryValidationHelpers
      module InstanceMethods
        FEATURE_TYPES = %w(
          Point
          MultiPoint
          LineString
          MultiLineString
          Polygon
          MultiPolygon
          GeometryCollection
        ).freeze

        def validates_geometry(atts, opts = {})
          validatable_attributes(atts, opts.merge(:message => 'is an invalid geometry')) do |attribute, value, message|
            validation_error_message(message) unless valid_geometry?(value)
          end
        end

        private

        def valid_geometry?(geojson)
          begin
            geometry = GeoRuby::GeojsonParser.new.parse(geojson).as_json
          rescue
            return false
          end

          type = geometry[:type]
          coordinates = geometry[:coordinates]

          FEATURE_TYPES.include?(type) && coordinates.kind_of?(Array) && !coordinates.empty?
        end
      end
    end
  end
end
