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

    BODY_TEMPLATE = File.read(File.join(Citygram::App.root, '/app/views/email.erb')).freeze

    def self.mail(opts)
      Pony.mail(opts)
    end

    def body
      events = Event.from_subscription(subscription)
      ERB.new(BODY_TEMPLATE).result(binding)
    end

    def call
      self.class.mail(
        to: subscription.email_address,
        subject: "Citygram #{subscription.publisher.title} notifications",
        html_body: body,
      )
    end
  end
end

Citygram::Services::Channels[:email] = Citygram::Services::Channels::Email
