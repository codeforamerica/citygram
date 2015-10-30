require 'json'

module Citygram
  module Models
    class City < Struct.new(:id, :title, :background, :center, :zoom, :sub_cities)
      NotFound = Class.new(StandardError)

      def self.all
        @all ||= begin
          geojson = JSON.parse(File.read(File.join(Citygram::App.root, 'config', 'cities.geojson')))
          cities = geojson['features'].map { |feature|
            Citygram::Models::City.new(
              feature['id'],
              feature['properties']['title'],
              feature['properties']['background'],
              feature['geometry']['coordinates'],
              feature['properties']['zoom'],
              feature['features']
            )
          }

          cities
        end
      end

      def self.find(id)
        all.find{ |city| city.id == id } || raise(NotFound, id)
      end

      self.all # load cities, fail fast
    end
  end
end
