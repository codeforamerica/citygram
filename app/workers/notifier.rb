module Georelevent
  module Workers
    class Notifier
      include Sidekiq::Worker

      def perform(subscription_id, event_id)
        subscription = Subscription.first!(id: subscription_id)
        event = Event.first!(id: event_id)
        webhook(subscription.connection, event.attributes.to_json)
      end

      def webhook(connection, body)
        connection.post do |req|
          req.body = body
        end
      end
    end
  end
end
