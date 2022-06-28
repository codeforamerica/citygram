module Citygram::Models
  class Publisher < Sequel::Model
    one_to_many :subscriptions
    one_to_many :events
    many_to_one :sms_credentials
    one_to_many :outages

    plugin :url_validation
    plugin :serialization, :pg_array, :tags

    dataset_module do
      def tagged(tag)
        where('? = ANY (tags)', tag)
      end

      def visible
        where(visible: true)
      end

      def active
        where(active: true)
      end
    end
    
    def credential_name
      sms_credentials.credential_name
    end
    def from_number
      sms_credentials.from_number
    end
    def account_sid
      sms_credentials.account_sid
    end
    def auth_token
      sms_credentials.auth_token
    end

    #delegate :credential_name, :from_number, :account_sid, :auth_token, to: :sms_credentials
    
    
    def active_outage
      Outage.by_publisher(self.id).active.first
    end
    
    def open_outage(error)
      if active_outage
        active_outage.touch
      else
        Outage.create(publisher_id: self.id)
      end
    end
    
    def close_outage
      active_outage.close! if active_outage
    end

    def validate
      super
      validates_presence [:title, :endpoint, :city, :icon]
      validates_url :endpoint
      validates_url :event_display_endpoint unless (event_display_endpoint.nil?)
      validates_unique :endpoint
    end
  end
end
