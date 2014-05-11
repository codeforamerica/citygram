source 'https://rubygems.org'

if ENV['CI']
  ruby RUBY_VERSION
else
  ruby '2.1.2'
end

gem 'dedent'
gem 'dotenv', '~> 0.11'
gem 'pg'
gem 'rake'
gem 'sequel', '~> 4.10'
gem 'sinatra', '~> 1.4'
gem 'sinatra-sequel', github: 'invisiblefunnel/sinatra-sequel', ref: '281677c'
gem 'unicorn'

group :test do
  gem 'rack-test'
  gem 'rspec', '~> 2.14'
end
