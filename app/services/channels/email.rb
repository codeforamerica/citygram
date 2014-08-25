require 'pony'

module Citygram::Services::Channels
  class Email < Base
    Pony.options = {
      from: ENV.fetch('SMTP_FROM_ADDRESS'),
      via: :smtp,
      via_options: {
        enable_starttls_auto: true,
        authentication: :plain,
        address:        ENV.fetch('SMTP_ADDRESS'),
        port:           ENV.fetch('SMTP_PORT'),
        user_name:      ENV.fetch('SMTP_USER_NAME'),
        password:       ENV.fetch('SMTP_PASSWORD'),
        domain:         ENV.fetch('SMTP_DOMAIN'),
      }
    }

    def call
      Pony.mail(
        to: subscription.email_address,
        subject: event.title
      )
    end
  end
end

Citygram::Services::Channels[:email] = Citygram::Services::Channels::Email
