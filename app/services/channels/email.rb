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

    BODY_TEMPLATE = ERB.new(File.read(File.join(Citygram::App.root, '/app/views/email.erb')))

    def self.body(subscription)
      @subscription = subscription
      @events = Event.from_subscription(@subscription, Event.date_defaults)
      context = binding
      BODY_TEMPLATE.result(context)
    end

    def self.mail(opts)
      Pony.mail(opts)
    end

    def call
      self.class.mail(
        to: subscription.email_address,
        subject: "Citygram #{subscription.publisher.title} notifications",
        html_body: self.class.body(subscription),
      )
    end
  end
end

Citygram::Services::Channels[:email] = Citygram::Services::Channels::Email
