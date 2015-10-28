module Citygram::Models
  class Publisher < Sequel::Model
    one_to_many :subscriptions
    one_to_many :events

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

    def validate
      super
      validates_presence [:title, :endpoint, :city, :icon]
      validates_url :endpoint
      validates_url :event_display_endpoint unless (event_display_endpoint.nil?)
      validates_unique :endpoint
    end
  end
end
