Sequel.migration do
  up do
    execute %{ CREATE EXTENSION "postgis"; }
  end

  down do
    execute %{ DROP EXTENSION "postgis"; }
  end
end
