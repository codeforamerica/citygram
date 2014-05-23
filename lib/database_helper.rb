require 'dedent'
require 'uri'
require File.expand_path('../../app', __FILE__)
Sequel.extension :migration

module DatabaseHelper
  PG_ERROR = /error|fail|fatal/i
  MIGRATION_TEMPLATE = <<-TEMPLATE.dedent.freeze
    Sequel.migration do
      up do
      end

      down do
      end
    end
  TEMPLATE

  def app
    Georelevent::App
  end

  def database
    app.database
  end

  def migration_path
    @migration_path ||= File.join(app.root, 'db/migrations')
  end

  def schema_path
    @schema_path ||= File.join(app.root, 'db/schema.sql')
  end

  def db_name
    @db_name ||= URI(database.url).path.gsub('/', '')
  end

  def db_version
    database.tables.include?(:schema_info) ? database[:schema_info].first[:version].to_i : 0
  end

  def migrate_db(version = nil)
    if version
      Sequel::Migrator.run(database, migration_path, target: version.to_i)
    else
      Sequel::Migrator.run(database, migration_path)
    end

    schema_dump
  rescue Sequel::Migrator::Error => e
    puts e
  end

  def generate_migration(name)
    next_version = format('%03d', db_version + 1)
    path = "db/migrations/#{next_version}_#{name}.rb"
    File.write(path, MIGRATION_TEMPLATE+"\n")
  end

  def create_db
    pg_command("createdb #{db_name} -w")
  end

  def drop_db
    tables = database.tables - [:spatial_ref_sys]

    tables.each do |table|
      database.run("DROP TABLE #{table} CASCADE")
    end
  end

  def schema_dump
    `rm #{schema_path}`
    pg_command("pg_dump -i -s -x -O -f #{schema_path} #{db_name}")
  end

  def rollback_db(version = nil)
    previous_version = version || db_version - 1
    migrate_db(previous_version)
  end

  def reset
    drop_db
    create_db
    migrate_db
  end

  def pg_command(command)
    res = system(command)
    raise res if PG_ERROR === res
  end

  def console
    require 'factory_girl'
    require 'ffaker'
    require File.join(app.root, 'spec/factories')
    include FactoryGirl::Syntax::Methods
    require 'irb'
    ARGV.clear
    IRB.start
  end
end
