Sequel.migration do
  up do
    execute %{ CREATE EXTENSION IF NOT EXISTS "postgis"; }
  end

  down do
    execute %{ DROP EXTENSION "postgis"; }
  end
end
