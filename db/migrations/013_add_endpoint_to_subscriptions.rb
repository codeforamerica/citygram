Sequel.migration do
  up do
    alter_table :subscriptions do
      add_column :endpoint, String, null: false
    end
  end

  down do
    alter_table :subscriptions do
      drop_column :endpoint
    end
  end
end
