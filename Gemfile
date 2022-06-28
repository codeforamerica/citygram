source 'https://rubygems.org'

if ENV['CI']
  ruby RUBY_VERSION
else
  ruby '2.7.6'
end

gem 'activesupport', require: 'active_support'
gem 'airbrake', require: false
gem 'dedent'
gem 'dotenv', '~> 1.0'
gem 'faraday'
gem 'faraday_middleware'
gem 'georuby', '~> 2.3.0'
gem 'grape', '~> 1.6'
gem 'json'
gem 'pg'
gem 'phone', '~> 1.3.0.beta0'
gem 'pony', '~> 1.9'
gem 'rack-cors', :require => 'rack/cors'
gem 'rack-ssl'
gem 'rake'
gem 'sassc', '~> 2.4'
gem 'sequel', '5.57'
gem 'sidekiq', '~> 6.5'
gem 'sinatra', '~> 2.2'
gem 'sprockets', '~> 4.1'
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
  gem 'factory_bot'
  gem 'rack-test'
  gem 'rspec', '~> 3.0'
  gem 'webmock'
end
