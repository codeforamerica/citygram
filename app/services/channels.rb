module Citygram
  module Services
    module Channels
      REGISTRY = {}

      def self.[]=(name, klass)
        REGISTRY[name.to_sym] = klass
      end

      def self.[](name)
        REGISTRY[name.to_sym] || raise(NotFound, "missing notification channel: #{name}")
      end

      def self.available
        REGISTRY.keys
      end

      class NotFound < StandardError; end
      class NotificationFailure < StandardError; end
    end
  end
end

require 'app/modules/sms_sender'
require 'app/services/channels/base'
require 'app/services/channels/email'
require 'app/services/channels/sms'
require 'app/services/channels/webhook'
