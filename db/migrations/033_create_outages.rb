Sequel.migration do
  up do
    create_table :outages do
      primary_key :id
      foreign_key :publisher_id, :publishers
      TrueClass   :active, default: true
      String      :maintainer
      DateTime    :updated_at
      DateTime    :created_at
      DateTime    :ended_at
    end
  end

  down do
    drop_table :outages
  end
end
