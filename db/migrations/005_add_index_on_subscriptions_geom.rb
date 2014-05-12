Sequel.migration do
  up do
    execute %{ CREATE INDEX subscriptions_geom_gist ON subscriptions USING GIST (geom); }
  end

  down do
    execute %{ DROP INDEX subscriptions_geom_gist; }
  end
end
