require_relative '../database_helper'
include DatabaseHelper

desc 'Run and interaction REPL session'
task :console do
  console
end

namespace :db do
  desc 'Reset the database'
  task :reset do
    reset
  end

  desc 'Drop the database'
  task :drop do
    drop_db
  end

  desc 'Create the database'
  task :create do
    create_db
  end

  desc 'Migrate to latest or specifiy a version'
  task :migrate, [:version] do |t, args|
    migrate_db(args[:version])
  end

  desc 'Rollback to the previous version or specify a version'
  task :rollback, [:version] do |t, args|
    rollback_db(args[:version])
  end
end

namespace :g do
  desc 'Generate a new migration file'
  task :migration, [:name] do |t, args|
    raise 'Must pass name: rake g:migration[add_index_to_table]' unless args[:name]
    generate_migration(args[:name])
  end
end
