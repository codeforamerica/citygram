Sequel.migration do
  up do
    alter_table :publishers do
      add_column :event_display_endpoint, 'text', null: true
    end
  end

  down do
    alter_table :publishers do
      drop_column :event_display_endpoint
    end
  end
end
