Sequel.migration do
  up do
    alter_table :subscriptions do
      add_column :last_notified, DateTime
    end    
  end

  down do
    alter_table :subscriptions do
      drop_column :last_notified
    end    
  end
end
