module Citygram
  module Workers
    class SubscriptionConfirmation
      include Sidekiq::Worker
      sidekiq_options retry: 5

      def perform(subscription_id)
        subscription = Subscription.first!(id: subscription_id)
        publisher = subscription.publisher

        # TODO: get rid of this case statement
        case subscription.channel
        when 'sms'
          body = "Welcome! You are now subscribed to #{publisher.title} in #{publisher.city}. Woohoo! If you'd like to give feedback, text back with your email."

          Citygram::Services::Channels::SMS.sms(
            from: Citygram::Services::Channels::SMS::FROM_NUMBER,
            to: subscription.phone_number,
            body: body
          )
        when 'email'
          # TODO
        end
      rescue Twilio::REST::RequestError => e
        Citygram::App.logger.error(e)
        raise NotificationFailure, e
      end
    end
  end
end
