module Citygram::Models
  class SmsCredentials < Sequel::Model
    dataset_module do
    end
    
    def validate
      super
      validates_presence [:from_number, :account_sid, :auth_token]
      validates_unique :account_sid
    end
  end
end