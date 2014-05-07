require 'dedent'
require File.expand_path('../../app', __FILE__)
Sequel.extension :migration

module DatabaseHelper
  def app
    Georelevent::App
  end

  def database
    app.database
  end

  def migration_path
    @migration_path ||= File.join(app.root, 'db/migrations')
  end

  def db_name
    @db_name ||= begin
      require 'uri'
      URI(database.url).path.gsub('/', '')
    end
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

    self
  rescue Sequel::Migrator::Error => e
    puts e
  end

  def generate_migration(name)
    next_version = format('%03d', db_version + 1)
    path = "db/migrations/#{next_version}_#{name}.rb"
    File.write(path, MIGRATION_TEMPLATE+"\n")

    self
  end

  def create_db
    res = `createdb #{db_name} -w`
    raise res if /ERROR/i === res

    self
  end

  def drop_db
    res = `dropdb #{db_name}`
    raise res if /ERROR/i === res

    self
  end

  def rollback_db(version = nil)
    previous_version = version || db_version - 1
    migrate_db(previous_version)

    self
  end

  def reset
    drop_db.create_db.migrate_db
  end

  def console
    require 'irb'
    ARGV.clear
    IRB.start
  end

  MIGRATION_TEMPLATE = <<-TEMPLATE.dedent.freeze
    Sequel.migration do
      up do
      end

      down do
      end
    end
  TEMPLATE
end
