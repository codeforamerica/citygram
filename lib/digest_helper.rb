require 'date'

module Citygram
  module DigestHelper
    def self.digest_day
      ENV.fetch('DIGEST_DAY').downcase
    end

    def self.today_as_digest_day
      Date.today.strftime('%A').downcase
    end

    def self.digest_day?
      digest_day == today_as_digest_day
    end

    def self.send
      ::Citygram::Workers::Notifier
      ::Subscription.notifiables.where(channel: 'email').paged_each do |subscription|
        if subscription.has_events?
          ::Citygram::Workers::Notifier.perform_async(subscription.id, nil)
        end
      end
    end
  end
end
