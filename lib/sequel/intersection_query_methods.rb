require 'geo_ruby/geojson'

module Sequel
  module Plugins
    module IntersectionQueryMethods
      module DatasetMethods
        def intersecting(geojson)
          where('ST_Intersects(geom, ?::geometry)', GeoRuby::GeojsonParser.new.parse(geojson).as_ewkt)
        end
      end

      # access the method from the class
      module ClassMethods
        Plugins.def_dataset_methods(self, :intersecting)
      end
    end
  end
end
