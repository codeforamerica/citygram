module Citygram
  module Services
    class PublisherUpdate < Struct.new(:features, :publisher)
      def self.call(*args)
        new(*args).call
      end

      def call
        new_events.tap do
          new_events.each(&method(:queue_notifications))
        end
      end

      def queue_notifications(event)
        Subscription.for_event(event).select(:id).paged_each do |subscription|
          Citygram::Workers::Notifier.perform_async(subscription.id, event.id)
        end
      end

      def new_events
        @new_events ||= features.lazy.
          map(&method(:wrap_feature)).
          map(&method(:build_event)).
          select(&method(:save_event?)).
          force
      end

      # wrap feature in a helper class to
      # provide method access to nested attributes
      # and granular control over the values
      def wrap_feature(feature)
        Feature.new(feature)
      end

      # build event instance from the wrapped
      # feature and assign the publisher
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

      # attempt to save the event, relying on
      # model validations for deduplication,
      # select iff the event has not been seen before.
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
