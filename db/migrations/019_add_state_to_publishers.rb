Sequel.migration do
  up do
    alter_table :publishers do
      add_column :state, String
    end
  end

  down do
    alter_table :publishers do
      drop_column :state
    end
  end
end
