Sequel.migration do
  up do
    execute %{CREATE EXTENSION "uuid-ossp";}
  end

  down do
    execute %{DROP EXTENSION "uuid-ossp";}
  end
end
