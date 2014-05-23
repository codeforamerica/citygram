require 'database_cleaner'

cleaner = DatabaseCleaner[:sequel, connection: Sequel::Model.db]
cleaner.strategy = :transaction

RSpec.configure do |config|
  config.around do |example|
    cleaner.start
    example.run
    cleaner.clean
  end
end
