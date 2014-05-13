Sequel.migration do
  up do
    alter_table(:publishers) do
      add_column :updated_at, DateTime
      add_column :created_at, DateTime
    end
  end

  down do
    alter_table(:publishers) do
      drop_column :updated_at
      drop_column :created_at
    end
  end
end
