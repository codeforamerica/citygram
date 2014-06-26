module Citygram
  module Services
    module Notifications
      CHANNELS = {}

      def self.add_channel(name, klass)
        CHANNELS[name.to_sym] = klass
      end

      def self.[](name)
        CHANNELS[name.to_sym] || raise("missing notification type: #{name}")
      end

      def self.available_channels
        CHANNELS.keys.map(&:to_s)
      end

      class NotificationFailure < StandardError; end
    end
  end
end

require 'app/services/notifications/base'
require 'app/services/notifications/email'
require 'app/services/notifications/sms'
require 'app/services/notifications/webhook'
