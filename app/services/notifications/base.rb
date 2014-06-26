module Citygram
  module Services
    module Notifications
      class Base < Struct.new(:subscription, :event)
        def self.call(subscription, event)
          new(subscription, event).call
        end

        def call
          raise 'abstract - must subclass'
        end
      end
    end
  end
end
