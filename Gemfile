source 'https://rubygems.org'

if ENV['CI']
  ruby RUBY_VERSION
else
  ruby '2.1.2'
end

gem 'activesupport'
gem 'dedent'
gem 'dotenv', '~> 0.11'
gem 'georuby', '~> 2.1'
gem 'pg'
gem 'rake'
gem 'sequel', '~> 4.10'
gem 'sinatra', '~> 1.4'
gem 'unicorn'

group :test do
  gem 'database_cleaner'
  gem 'rack-test'
  gem 'rspec', '~> 2.14'
end
