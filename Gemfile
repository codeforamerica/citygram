source 'https://rubygems.org'

if ENV['CI']
  ruby RUBY_VERSION
else
  ruby '2.0.0'
end

gem 'activesupport'
gem 'airbrake', require: false
gem 'bootstrap-sass', '3.2.0.2'
gem 'dedent'
gem 'dotenv', '~> 0.11'
gem 'faraday', '~> 0.9'
gem 'faraday_middleware', '~> 0.9'
gem 'georuby', '~> 2.1'
gem 'grape', '~> 0.7'
gem 'pg'
gem 'phone', '~> 1.3.0.beta0'
gem 'pony', '~> 1.9'
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
  gem 'debugger'
  gem 'foreman'
end

group :test do
  gem 'factory_girl'
  gem 'ffaker'
  gem 'rack-test'
  gem 'rspec', '~> 3.0'
  gem 'webmock'
end
