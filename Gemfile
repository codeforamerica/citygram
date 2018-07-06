source 'https://rubygems.org'

if ENV['CI']
  ruby RUBY_VERSION
else
  ruby '2.5.0'
end

gem 'activesupport', require: 'active_support'
gem 'airbrake', require: false
gem 'dedent'
gem 'dotenv', '~> 1.0'
gem 'faraday', '~> 0.9'
gem 'faraday_middleware', '~> 0.9'
gem 'georuby', '~> 2.3.0'
gem 'grape', '~> 0.9.0'
gem 'json', github: 'flori/json', branch: 'v1.8' # https://github.com/flori/json/issues/253#issuecomment-336528624
gem 'pg'
gem 'phone', '~> 1.3.0.beta0'
gem 'pony', '~> 1.9'
gem 'rack-cors', :require => 'rack/cors'
gem 'rack-ssl'
gem 'rake'
gem 'sass', '~> 3.4'
gem 'sequel', '4.12'
gem 'sidekiq', '~> 3.0'
gem 'sinatra', '~> 1.4'
gem 'sprockets', '~> 2.12'
gem 'twilio-ruby', '~> 3.11'
gem 'uglifier'
gem 'unicorn'

group :production do
  gem 'newrelic_rpm', require: false
end

group :development do
  gem 'foreman'
end

group :test do
  gem 'factory_girl'
  gem 'rack-test'
  gem 'rspec', '~> 3.0'
  gem 'webmock'
end
