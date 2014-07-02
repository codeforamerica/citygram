Sequel.migration do
  up do
    alter_table :publishers do
      add_column :active, TrueClass
      add_column :city, String
      add_column :icon, String
    end
  end

  down do
    alter_table :publishers do
      drop_column :active
      drop_column :city
      drop_column :icon
    end
  end
end