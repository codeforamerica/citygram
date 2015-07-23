require 'date'

module Citygram
  class DigestHelper
    def digest_day
      ENV.fetch('DIGEST_DAY').downcase
    end

    def today_as_digest_day
      Date.today.strftime('%A').downcase
    end

    def digest_day?
      digest_day == today_as_digest_day
    end

    def send_notifications
      ::Subscription.notifiables.where(channel: 'email').paged_each do |subscription|
        if subscription.has_events?
          ::Citygram::Workers::Notifier.perform_async(subscription.id, nil)
        end
      end
    end

    def send_notifications_if_digest_day
      send_notifications if digest_day?
    end
  end
end
