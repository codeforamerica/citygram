source 'https://rubygems.org'

if ENV['CI']
  ruby RUBY_VERSION
else
  ruby '2.1.2'
end

gem 'activesupport'
gem 'airbrake', require: false
gem 'dedent'
gem 'dotenv', '~> 0.11'
gem 'faraday', '~> 0.9'
gem 'faraday_middleware', '~> 0.9'
gem 'georuby', '~> 2.1'
gem 'grape', '~> 0.7'
gem 'newrelic_rpm'
gem 'pg'
gem 'rake'
gem 'sass', '~> 3.3'
gem 'sequel', '~> 4.10'
gem 'sidekiq', '~> 3.0'
gem 'sinatra', '~> 1.4'
gem 'sinatra-assetpack', '~> 0.3'
gem 'unicorn'

group :development do
  gem 'foreman'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'ffaker'
  gem 'rack-test'
  gem 'rspec', '~> 3.0'
  gem 'webmock'
end
