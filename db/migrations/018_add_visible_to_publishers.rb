Sequel.migration do
  up do
    alter_table :publishers do
      add_column :visible, TrueClass, default: true
    end
  end

  down do
    alter_table :publishers do
      drop_column :visible
    end
  end
end
