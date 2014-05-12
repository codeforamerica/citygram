require './app'
run Rack::Cascade.new [
  Georelevent::App,
  Georelevent::Routes::Subscriptions
]
