require 'json'

module Citygram
  module Models
    class City < Struct.new(:tag, :title, :center, :zoom)
      NotFound = Class.new(StandardError)

      def self.all
        @all ||= begin
          collection = JSON.parse(File.read(File.join(Citygram::App.root, 'config', 'cities.geojson')))
          cities = collection['features'].map { |feature|
            Citygram::Models::City.new(
              feature['id'],
              feature['properties']['title'],
              feature['geometry']['coordinates'],
              feature['properties']['zoom']
            )
          }

          cities
        end
      end

      def self.find(tag)
        all.find{ |city| city.tag == tag } || raise(NotFound, tag)
      end

      self.all # load cities, fail fast
    end
  end
end
