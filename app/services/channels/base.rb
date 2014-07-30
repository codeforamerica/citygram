module Citygram
  module Services
    module Channels
      class Base < Struct.new(:subscription, :event)
        def self.call(subscription, event)
          new(subscription, event).call
        end

        def call
          raise 'abstract - must subclass'
        end

        def suppress
          Citygram::App.logger.info 'SUPPRESSED: class=%s subscription_id=%s event_id=%s' % [
            self.class.name,
            subscription.id,
            event.id
          ]
        end
      end
    end
  end
end
