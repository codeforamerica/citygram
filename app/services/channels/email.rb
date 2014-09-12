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

    def self.body(subscription)
      @events = Event.from_subscription(subscription, Event.date_defaults)
      context = binding
      ERB.new(File.read(File.join(Citygram::App.root, '/app/views/_digest_events.erb'))).result(context)
    end

    def call
      Pony.mail(
        to: subscription.email_address,
        subject: "Citygram #{subscription.publisher.title} notifications",
        body: self.class.body(subscription),
      )
    end
  end
end

Citygram::Services::Channels[:email] = Citygram::Services::Channels::Email
