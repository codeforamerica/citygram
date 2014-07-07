require 'app/services/channels'

module Citygram
  module Workers
    class Notifier
      include Sidekiq::Worker
      sidekiq_options retry: 10

      def perform(subscription_id, event_id)
        subscription = Subscription.first!(id: subscription_id)
        event = Event.first!(id: event_id)
        Citygram::Services::Channels[subscription.channel].call(subscription, event)
      end
    end
  end
end
