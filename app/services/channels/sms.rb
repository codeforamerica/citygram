module Citygram::Services::Channels
  class SMS < Base
    
    include ::Citygram::SmsSender


    UNSUBSCRIBE_ERROR_CODES = [
      21211, # number cannot exist - https://www.twilio.com/docs/errors/21211
      21610, # user replied with a stop word - https://www.twilio.com/docs/errors/21610
      21614, # not a valid mobile number - https://www.twilio.com/docs/errors/21614
    ].freeze

    def self.sms(sid, token, *args)
      client = Twilio::REST::Client.new(sid, token)
      client.account.messages.create(*args)
    end

    def call
      send_sms(subscription, event.title)
    rescue Twilio::REST::RequestError => e
      Citygram::App.logger.error(e)

      if UNSUBSCRIBE_ERROR_CODES.include?(e.code.to_i)
        subscription.unsubscribe! # and skip retries
      else
        raise NotificationFailure, e
      end
    end
  end
end

Citygram::Services::Channels[:sms] = Citygram::Services::Channels::SMS
