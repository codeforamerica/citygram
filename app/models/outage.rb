module Citygram::Models
  class Outage < Sequel::Model
    many_to_one :publisher

    dataset_module do
    end

    def validate
      super
      validates_presence [:publisher_id]
    end
  end
end
