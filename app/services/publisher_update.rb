module Georelevent
  module Services
    class PublisherUpdate < Struct.new(:features, :publisher)
      def self.call(*args)
        new(*args).call
      end

      def call
        new_events.each do |event|
          queue_notifications(event)
        end
      end

      def queue_notifications(event)
        Subscription.for_event(event).select(:id).paged_each do |subscription|
          Georelevent::Workers::Notifier.perform_async(subscription.id, event.id)
        end
      end

      def new_events
        features.lazy.
        # wrap each feature in a helper class to
        # provide method access to nested attributes
        # and granular control over the values
        map(&method(:wrap_feature)).
        # build event instances from the wrapped
        # features and assign the publisher
        map(&method(:build_event)).
        # attempt to save each event, relying on
        # model validations for deduplication,
        # select only the new events
        select(&method(:save_event?)).
        # evaluate the lazy enumeration
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
          e.properties   = feature.properties
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
      end
    end
  end
end
