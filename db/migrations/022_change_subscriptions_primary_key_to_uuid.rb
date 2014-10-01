Sequel.migration do
  up do
    alter_table :subscriptions do
      drop_column :id
      add_column :id, :uuid, default: Sequel.function(:uuid_generate_v4), primary_key: true
    end
  end

  down do
    alter_table :subscriptions do
      drop_column :id
      add_primary_key :id
    end
  end
end
