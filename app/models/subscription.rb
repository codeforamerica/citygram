require 'app/services/channels'

module Citygram::Models
  class Subscription < Sequel::Model
    many_to_one :publisher

    set_allowed_columns \
      :channel,
      :email_address,
      :phone_number,
      :webhook_url,
      :geom,
      :publisher_id

    plugin :email_validation
    plugin :geometry_validation
    plugin :phone_validation
    plugin :serialization, :geojson, :geom
    plugin :serialization, :phone, :phone_number
    plugin :url_validation

    dataset_module do
      def notifiables
        # should enforce has_events but the spatial join is hairy
        active.where(:publisher => Publisher.active)
      end

      def active
        where(unsubscribed_at: nil)
      end

      def unsubscribe!
        update(unsubscribed_at: DateTime.now)
      end
    end

    def has_events?
      Event.from_subscription(self).count > 0
    end

    def unsubscribe!
      self.unsubscribed_at = DateTime.now
      save!
    end

    def validate
      super
      validates_presence [:geom, :publisher_id, :channel]
      validates_includes Citygram::Services::Channels.available.map(&:to_s), :channel

      case channel
      when 'webhook'
        validates_url :webhook_url
      when 'email'
        validates_email :email_address
      when 'sms'
        validates_phone :phone_number
      end

      validates_geometry :geom
    end
  end
end
