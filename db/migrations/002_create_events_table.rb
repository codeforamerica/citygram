Sequel.migration do
  up do
    create_table :events do
      primary_key :id
      String :title
      String :description, type: :text
      column :geom, :geometry
      DateTime :updated_at
      DateTime :created_at
    end
  end

  down do
    drop_table :events
  end
end
