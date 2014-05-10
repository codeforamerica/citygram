require 'bundler'
Bundler.require

# require rake tasks
Dir['./lib/tasks/**/*.rake'].each { |f| load(f) }

# declare default rake task
desc 'Run the entire test suite'
task default: :test
