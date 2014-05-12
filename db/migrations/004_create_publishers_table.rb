Sequel.migration do
  up do
    create_table :publishers do
      primary_key :id
      String :title
      String :endpoint
    end
  end

  down do
    drop_table :publishers
  end
end
