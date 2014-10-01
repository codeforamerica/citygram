require_relative '../database_helper'

desc 'Run an interactive REPL session'
task :console do
  Citygram::DatabaseHelper.console(self)
end

namespace :db do
  desc 'Reset the database'
  task :reset do
    Citygram::DatabaseHelper.reset
  end

  desc 'Drop the database'
  task :drop do
    Citygram::DatabaseHelper.drop_db
  end

  desc 'Create the database'
  task :create do
    Citygram::DatabaseHelper.create_db
  end

  desc 'Migrate to latest or specifiy a version'
  task :migrate, [:version] do |t, args|
    Citygram::DatabaseHelper.migrate_db(args[:version])
  end

  desc 'Rollback to the previous version or specify a version'
  task :rollback, [:version] do |t, args|
    Citygram::DatabaseHelper.rollback_db(args[:version])
  end

  desc 'Dump the schema as sql'
  task :schema_dump do
    Citygram::DatabaseHelper.schema_dump
  end
end

namespace :g do
  desc 'Generate a new migration file'
  task :migration, [:name] do |t, args|
    raise 'Must pass name: rake g:migration[add_index_to_table]' unless args[:name]
    Citygram::DatabaseHelper.generate_migration(args[:name])
  end
end
