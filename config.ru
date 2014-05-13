require './app'
run Rack::Cascade.new [
  Georelevent::Routes::Subscriptions,
  Georelevent::Routes::Home
]
