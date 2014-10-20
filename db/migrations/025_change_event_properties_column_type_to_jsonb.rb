Sequel.migration do
  transaction

  up do
    alter_table :events do
      add_column :tmp_properties, :json, default: Sequel.lit(%{'{}'::json})
    end

    run %{UPDATE events SET tmp_properties = properties::json}

    alter_table :events do
      drop_column :properties
      rename_column :tmp_properties, :properties
    end
  end

  down do
    alter_table :events do
      add_column :tmp_properties, :text, default: {}.to_json
    end

    run %{UPDATE events SET tmp_properties = properties::json}

    alter_table :events do
      drop_column :properties
      rename_column :tmp_properties, :properties
    end
  end
end
