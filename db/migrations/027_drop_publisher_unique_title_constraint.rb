Sequel.migration do
  up do
    alter_table :publishers do
      drop_index :title
    end
  end

  down do
    alter_table :publishers do
      add_index :title, unique: true
    end
  end
end
