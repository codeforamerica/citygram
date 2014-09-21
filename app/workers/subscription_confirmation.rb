module Citygram::Workers
  class SubscriptionConfirmation
    include Sidekiq::Worker
    sidekiq_options retry: 5

    def perform(subscription_id)
      subscription = Subscription.first!(id: subscription_id)
      publisher = subscription.publisher

      # TODO: get rid of this case statement
      case subscription.channel
      when 'sms'
        body = "Welcome! You are now subscribed to #{publisher.title} in #{publisher.city}. Woohoo! If you'd like to give feedback, text back with your email. To unsubscribe from all messages, reply STOP."

        Citygram::Services::Channels::SMS.sms(
          from: Citygram::Services::Channels::SMS::FROM_NUMBER,
          to: subscription.phone_number,
          body: body
        )
      when 'email'
        url = Citygram::Routes::Helpers.build_url(Citygram::App.application_url, "/digests/#{subscription.id}/events")

        body = <<-BODY.dedent
          <p>Thank you for subscribing! <a href="#{url}">View Citygrams</a> in a browser.</p>
        BODY

        Citygram::Services::Channels::Email.mail(
          to: subscription.email_address,
          subject: "Citygram: You're subscribed to #{publisher.city} #{publisher.title}",
          html_body: body,
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
