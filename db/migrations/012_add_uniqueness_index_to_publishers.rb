Sequel.migration do
  up do
    alter_table :publishers do
      add_index :title, unique: true
      add_index :endpoint, unique: true
    end
  end

  down do
    alter_table :publishers do
      drop_index :title
      drop_index :endpoint
    end
  end
end
