module Citygram::Models
  class Outage < Sequel::Model
    many_to_one :publisher
    
    set_allowed_columns :publisher_id, :updated_at

    dataset_module do
      def active
        where(active: true)
      end
      
      def by_publisher(publisher_id)
        where(:publisher_id=>publisher_id)
      end
    end

    def active?
      active
    end
    
    def close!
      self.ended_at = DateTime.now
      self.active = false
      save!
    end
    
    def validate
      super
      validates_presence [:publisher_id]
    end
  end
end
