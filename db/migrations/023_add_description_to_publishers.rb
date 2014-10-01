Sequel.migration do
  up do
    alter_table :publishers do
      add_column :description, String
    end
  end

  down do
    alter_table :publishers do
      drop_column :description
    end
  end
end
