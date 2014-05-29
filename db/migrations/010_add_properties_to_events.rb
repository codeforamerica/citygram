Sequel.migration do
  up do
    alter_table :events do
      add_column :properties, String, default: {}.to_json
    end
  end

  down do
    alter_table :events do
      drop_column :properties
    end
  end
end
