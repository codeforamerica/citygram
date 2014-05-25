module Georelevent
  module Workers
    class PublisherUpdate < Struct.new(:features, :publisher)
      def call
        features.lazy.
          map(&method(:build_event)).
          select(&method(:save_event?)).
          force
      end

      def build_event(feature)
        Event.new do |e|
          e.publisher_id = publisher.id
          e.feature_id   = feature['id']
          e.title        = feature['properties']['title']
          e.description  = feature['properties']['description']
          e.geom         = feature['geometry'].to_json
        end
      end

      def save_event?(event)
        event.save
      end
    end
  end
end
