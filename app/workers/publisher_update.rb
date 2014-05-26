module Georelevent
  module Workers
    class PublisherUpdate < Struct.new(:features, :publisher)
      def call
        features.lazy.
          map(&method(:wrap_feature)).
          map(&method(:build_event)).
          select(&method(:save_event?)).
          force
      end

      def wrap_feature(feature)
        Feature.new(feature)
      end

      def build_event(feature)
        Event.new do |e|
          e.publisher_id = publisher.id
          e.feature_id   = feature.id
          e.title        = feature.title
          e.description  = feature.description
          e.geom         = feature.geometry
        end
      end

      def save_event?(event)
        event.save
      end

      class Feature < Struct.new(:data)
        def id
          data['id']
        end

        def title
          properties['title']
        end

        def description
          properties['description']
        end

        def geometry
          data['geometry'].to_json
        end

        def properties
          data['properties'] || {}
        end
      end # Feature
    end # PublisherUpdate
  end # Workers
end # Georelevent
