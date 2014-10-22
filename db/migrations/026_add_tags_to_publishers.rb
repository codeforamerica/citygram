Sequel.migration do
  up do
    alter_table :publishers do
      add_column :tags, 'text[]', default: '{}', null: false
    end
  end

  down do
    alter_table :publishers do
      drop_column :tags
    end
  end
end
