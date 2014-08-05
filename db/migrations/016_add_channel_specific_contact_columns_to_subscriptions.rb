Sequel.migration do
  up do
    alter_table :subscriptions do
      add_column :phone_number, String
      add_column :email_address, String
      add_column :webhook_url, String
    end

    run <<-SQL.dedent
      UPDATE subscriptions SET phone_number = contact
    SQL

    alter_table :subscriptions do
      drop_column :contact
    end
  end

  down do
    alter_table :subscriptions do
      add_column :contact, String
    end

    run <<-SQL.dedent
      UPDATE subscriptions SET contact = phone_number
    SQL

    alter_table :subscriptions do
      drop_column :phone_number
      drop_column :email_address
      drop_column :webhook_url
    end
  end
end
