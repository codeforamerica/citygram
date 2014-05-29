Sequel.migration do
  up do
    alter_table :events do
      add_column :feature_id, String
      add_index [:publisher_id, :feature_id], unique: true
    end
  end

  down do
    alter_table :events do
      drop_index [:publisher_id, :feature_id]
      drop_column :feature_id
    end
  end
end
