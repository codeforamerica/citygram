require 'geo_ruby/geojson'

module Citygram
  module Models
    module Plugins
      module GeometryValidation

        module InstanceMethods
          def validates_geometry(atts, opts = {})
            validatable_attributes(atts, opts.merge(message: 'is an invalid geometry')) do |attribute, value, message|
              validation_error_message(message) unless valid_geometry?(value)
            end
          end

          private

          def valid_geometry?(geojson)
            GeoRuby::GeojsonParser.new.parse(geojson).as_json
            true
          rescue
            false
          end
        end

      end
    end
  end
end
