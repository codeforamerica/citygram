require './app'

unprotected_routes = [
  Citygram::Routes::Events,
  Citygram::Routes::Publishers,
  Citygram::Routes::Subscriptions,
  Citygram::Routes::Pages,
  Citygram::Routes::Digests
]

protected_routes = [
  Citygram::Routes::Unsubscribes
]

run Rack::URLMap.new(
  '/' => Rack::Cascade.new(unprotected_routes),
  '/assets' => Citygram::App.assets,
  '/protected' => Rack::Cascade.new(protected_routes),
)
