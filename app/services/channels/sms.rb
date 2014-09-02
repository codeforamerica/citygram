module Citygram::Services::Channels
  class SMS < Base
    FROM_NUMBER = ENV.fetch('TWILIO_FROM_NUMBER')

    TWILIO_ACCOUNT_SID = ENV.fetch('TWILIO_ACCOUNT_SID').freeze
    TWILIO_AUTH_TOKEN  = ENV.fetch('TWILIO_AUTH_TOKEN').freeze

    UNSUBSCRIBE_ERROR_CODES = [
      21211, # number cannot exist - https://www.twilio.com/docs/errors/21211
      21610, # user replied with a stop word - https://www.twilio.com/docs/errors/21610
      21614, # not a valid mobile number - https://www.twilio.com/docs/errors/21614
    ].freeze

    def self.sms(*args)
      client = Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
      client.account.messages.create(*args)
    end

    def call
      self.class.sms(
        from: FROM_NUMBER,
        to: subscription.phone_number,
        body: event.title
      )
    rescue Twilio::REST::RequestError => e
      Citygram::App.logger.error(e)

      if UNSUBSCRIBE_ERROR_CODES.include?(e.code.to_i)
        subscription.unsubscribe! # and skip retries
      else
        raise NotificationFailure, e
      end
    rescue IOError => e # IOError's the source of duplicate sms's?
      Citygram::App.logger(e)
    end
  end
end

Citygram::Services::Channels[:sms] = Citygram::Services::Channels::SMS
