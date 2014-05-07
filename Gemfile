source 'https://rubygems.org'

if ENV['CI']
  ruby RUBY_VERSION
else
  ruby '2.1.1'
end

gem 'dotenv', '~> 0.11'
gem 'rake'
gem 'sinatra', '~> 1.4'
gem 'unicorn'

group :test do
  gem 'rack-test'
  gem 'rspec', '~> 2.14'
end
