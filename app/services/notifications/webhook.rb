require 'app/services/connection_builder'

module Citygram
  module Services
    module Notifications
      class Webhook < Base
        def call
          response = connection.post do |conn|
            conn.body = body
          end

          handle_response(response)
        end

        def connection
          Citygram::Services::ConnectionBuilder.json("request.subscription.#{subscription.id}", url: subscription.contact)
        end

        def body
          {
            event: event.attributes,
            subscription: subscription.attributes,
            publisher: event.publisher.attributes
          }.to_json
        end

        def handle_response(response)
          case response.status
          when 200..299 # job succeeded
          else # job failed, retry unless retries exhausted
            raise NotificationFailure, "HTTP status code: #{response.status}"
          end
        end
      end

      add_channel :webhook, Citygram::Services::Notifications::Webhook
    end
  end
end
