module Citygram::Models
  class SmsCredentials < Sequel::Model
    
    set_allowed_columns :credential_name, :account_sid,
                        :auth_token, :from_number
        
    dataset_module do
    end
    
    def validate
      super
      validates_presence [:from_number, :account_sid, :auth_token]
      validates_unique :account_sid
    end
  end
end