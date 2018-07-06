require './app'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: ['Content-Type'], methods: :get
  end
end

unprotected_routes = [
  Citygram::Routes::Events,
  Citygram::Routes::Publishers,
  Citygram::Routes::Subscriptions,
  Citygram::Routes::Digests,
  Citygram::Routes::Status
]

unprotected_routes << if ENV.fetch('ROOT_CITY_TAG', false)
  Citygram::Routes::Page
else
  Citygram::Routes::Pages
end

protected_routes = [
  Citygram::Routes::Unsubscribes
]

run Rack::URLMap.new(
  '/' => Rack::Cascade.new(unprotected_routes),
  '/assets' => Citygram::App.assets,
  '/protected' => Rack::Cascade.new(protected_routes),
)
