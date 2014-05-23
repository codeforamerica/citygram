require 'database_cleaner'

DatabaseCleaner[:sequel, connection: Sequel::Model.db].strategy = :transaction

RSpec.configure do |config|
  config.around do |example|
    DatabaseCleaner[:sequel, connection: Sequel::Model.db].start
    example.run
    DatabaseCleaner[:sequel, connection: Sequel::Model.db].clean
  end
end
