Sequel.migration do
  up do
    create_table :http_requests do
      column :id, :uuid, default: Sequel.function(:uuid_generate_v4), primary_key: true
      String :scheme, size: 255
      String :userinfo
      String :host
      Integer :port
      String :path
      String :query
      String :fragment
      String :method, size: 255
      Integer :response_status
      Integer :duration # milliseconds
      DateTime :started_at
    end
  end

  down do
    drop_table :http_requests
  end
end
