Sequel.migration do
  up do
    create_table :subscriptions do
      primary_key :id
      column :geom, :geometry
      DateTime :updated_at
      DateTime :created_at
    end
  end

  down do
    drop_table :subscriptions
  end
end
