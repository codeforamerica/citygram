require './app'
run Rack::Cascade.new [
  Citygram::API,
  Citygram::App
]
