desc 'Run the entire test suite'
task :test do
  ENV['RACK_ENV'] = 'test'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  Rake::Task[:spec].invoke
end
