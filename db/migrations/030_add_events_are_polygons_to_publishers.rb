Sequel.migration do
  up do
    alter_table :publishers do
      add_column :events_are_polygons, :boolean
    end
  end

  down do
    alter_table :publishers do
      drop_column :events_are_polygons
    end
  end
end
