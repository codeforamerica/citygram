require 'sidekiq'

module Citygram
  module Workers
  end
end

require 'app/workers/publisher_poll'
require 'app/workers/notifier'
require 'app/workers/middleware/database_connections'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Citygram::Workers::Middleware::DatabaseConnections, Citygram::App.database
  end
end
