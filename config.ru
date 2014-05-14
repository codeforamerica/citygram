require './app'
run Rack::Cascade.new [
  Georelevent::API,
  Georelevent::App
]
