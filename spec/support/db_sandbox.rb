RSpec.configure do |config|
  config.around do |example|
    Sequel::Model.db.transaction(rollback: :always, &example)
    Citygram::Models::Outage.plugin :timestamps, update_on_create: true, allow_manual_update: true
  end
end
