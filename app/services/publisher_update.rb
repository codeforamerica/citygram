module Citygram
  module Services
    class PublisherUpdate < Struct.new(:features, :publisher)
      def self.call(features, publisher)
        new(features, publisher).call
      end

      def call
        queue_notifications
        return new_events
      end

      def queue_notifications
        sql = <<-SQL.dedent
          SELECT subscriptions.id AS subscription_id, events.id AS event_id
          FROM subscriptions INNER JOIN events
            ON ST_Intersects(subscriptions.geom, events.geom)
            AND subscriptions.publisher_id = events.publisher_id
            AND subscriptions.unsubscribed_at IS NULL
            AND channel <> 'email'
          WHERE events.id in ?
        SQL

        dataset = Sequel::Model.db.dataset.with_sql(sql, new_events.map(&:id))

        dataset.paged_each do |pair|
          Citygram::Workers::Notifier.perform_async(pair[:subscription_id], pair[:event_id])
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
          data['id'] || properties['id']
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
