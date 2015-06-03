Sequel.migration do
  up do
    execute %{CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;}
  end

  down do
    execute %{DROP EXTENSION IF EXISTS pg_stat_statements;}
  end
end
