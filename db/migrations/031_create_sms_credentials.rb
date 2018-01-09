Sequel.migration do
  up do
    create_table :sms_credentials do
      primary_key :id
      String :credential_name
      String :from_number
      String :account_sid
      String :auth_token
      DateTime :updated_at
      DateTime :created_at
    end
  end

  down do
    drop_table :sms_credentials
  end
end
