require 'sidekiq'

module Georelevent
  module Workers
  end
end

require 'app/workers/publisher_poll'
require 'app/workers/notifier'
require 'app/workers/middleware/database_connections'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Georelevent::Workers::Middleware::DatabaseConnections, Georelevent::App.database
  end
end
