Sequel.migration do
  up do
    alter_table :subscriptions do
      add_column :unsubscribed_at, DateTime
    end
  end

  down do
    alter_table :subscriptions do
      drop_column :unsubscribed_at
    end
  end
end
