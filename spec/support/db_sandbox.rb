RSpec.configure do |config|
  config.around do |example|
    Sequel::Model.db.transaction(rollback: :always, &example)
  end
end
