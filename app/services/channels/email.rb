require 'pony'

module Citygram
  module Services
    module Channels
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
            to: subscription.contact,
            subject: event.title
          )
        end
      end

      Channels[:email] = Citygram::Services::Channels::Email
    end
  end
end
