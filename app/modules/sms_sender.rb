module Citygram
  module SmsSender

    def send_sms(subscription, body)
      Citygram::App.logger.info("Sending SMS via #{subscription.credential_name}")
      Citygram::Services::Channels::SMS.sms(
        subscription.account_sid, 
        subscription.auth_token, {
        from: subscription.from_number,
        to:   subscription.phone_number,
        body: body
      })
    end
  end
end