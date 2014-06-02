module Georelevent
  module Workers
    class Notifier
      include Sidekiq::Worker

      class NotificationFailure < StandardError; end

      def perform(subscription_id, event_id)
        subscription = Subscription.first!(id: subscription_id)
        event = Event.first!(id: event_id)
        webhook(subscription.connection, event.attributes.to_json)
      end

      def webhook(connection, body)
        response = connection.post do |req|
          req.body = body
        end

        handle_response(response)
      end

      def handle_response(response)
        case response.status
        when 200..299 # job succeeded
        else # job failed, retry unless retries exhausted
          raise NotificationFailure, "HTTP status code: #{response.status}"
        end
      end
    end
  end
end
