module Georelevent
  module Workers
    module Middleware
      class DatabaseConnections
        def initialize(database)
          @database = database
        end

        def call(*args)
          yield
        ensure
          @database.disconnect
        end
      end
    end
  end
end
