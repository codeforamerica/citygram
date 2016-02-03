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

      def email
        where(channel: 'email')
      end
      
      def sms
        where(channel: 'sms')
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
    
    def remind!
      self.last_notified = DateTime.now
      save!
    end
    
    def nominative
      self.email_address.blank? ? self.phone_number : self.email_address
    end
    
    def remindable?
      needs_activity_evaluation? && requires_notification?
    end

    def needs_activity_evaluation?
      Time.now > 2.weeks.since(last_notification)
    end
    
    def deliveries_since_last_notification
      Event.from_subscription(self, after_date: self.last_notification).count
    end
    
    def requires_notification?
      self.deliveries_since_last_notification >= 28
    end
    
    def last_notification
      self.last_notified || self.created_at
    end
    
    def last_notification_date
      self.last_notification.strftime("%b %d, %Y")
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
