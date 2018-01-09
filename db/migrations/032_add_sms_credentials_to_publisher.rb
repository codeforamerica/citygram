Sequel.migration do
  up do
    alter_table(:publishers) do
      add_foreign_key :sms_credentials_id, :sms_credentials
    end
  end

  down do
    alter_table(:publishers) do
      drop_foreign_key :sms_credentials_id
    end
  end
end
