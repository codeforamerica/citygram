Sequel.migration do
  up do
    alter_table(:events) do
      add_foreign_key :publisher_id, :publishers
    end
  end

  down do
    alter_table(:events) do
      drop_foreign_key :publisher_id
    end
  end
end
