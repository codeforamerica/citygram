require 'bundler'
Bundler.require

APP_FILE  = 'app.rb'
APP_CLASS = 'Sinatra::Application'

require 'sinatra/assetpack/rake'

# require rake tasks
Dir['./lib/tasks/**/*.rake'].each { |f| load(f) }

# declare default rake task
desc 'Run the entire test suite'
task default: :test

desc 'Load the application'
task :app do
  require './app'
end
