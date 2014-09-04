require 'sidekiq/testing'

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end

  config.around(:each) do |example|
    Sidekiq::Testing.fake!(&example)
  end
end
