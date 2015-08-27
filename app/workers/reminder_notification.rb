module Citygram::Workers
  class ReminderNotification
    include Sidekiq::Worker
    sidekiq_options retry: 5

    def reminder_url(subscription)
      Citygram::Routes::Helpers.build_url(Citygram::App.application_url, "/digests/#{subscription.id}/reminder")
    end
    
    def reminder_message(s)
      "Since #{s.last_notification_date}, we've sent you #{s.deliveries_since_last_notification} Citygrams about #{s.publisher.title} in #{s.publisher.city}"
    end
    
    def unsub_message(s)
      "For more information (or to unsubscribe): #{reminder_url(s)}"
    end
    
    def perform(subscription_id)
      subscription = Subscription.first!(id: subscription_id)
      # form messages based on current state...
      body_1, body_2 = [reminder_message(subscription), unsub_message(subscription)]
      
      # ...but if there is an error sending this message, tomorrow's might work
      subscription.remind!
      [body_1, body_2].each do |body|
        Citygram::Services::Channels::SMS.sms(
          from: Citygram::Services::Channels::SMS::FROM_NUMBER,
          to: subscription.phone_number,
          body: body
        )
      end
    rescue Twilio::REST::RequestError => e
      Citygram::App.logger.error(e)

      if Citygram::Services::Channels::SMS::UNSUBSCRIBE_ERROR_CODES.include?(e.code.to_i)
        # unsubscribe and skip retries
        subscription.unsubscribe!
      else
        raise Citygram::Services::Channels::NotificationFailure, e
      end
    end
  end
end
