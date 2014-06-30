Sequel.migration do
  up do
    alter_table :subscriptions do
      rename_column :endpoint, :contact
      add_column :channel, String, null: false
    end
  end

  down do
    alter_table :subscriptions do
      rename_column :contact, :endpoint
      drop_column :channel
    end
  end
end
