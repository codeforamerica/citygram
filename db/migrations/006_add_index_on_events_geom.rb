Sequel.migration do
  up do
    execute %{ CREATE INDEX events_geom_gist ON events USING GIST (geom); }
  end

  down do
    execute %{ DROP INDEX events_geom_gist; }
  end
end
