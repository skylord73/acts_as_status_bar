equire 'rails/generators'
require 'rails/generators/migration'

module ActsAsStatusBar
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    desc "Migration generator for ActsAsStatusBar gem"
    source_root File.expand_path("../templates", __FILE__)
    
    def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
    end

    
    def copy_migration
      migration_template "create_migration.rb", "db/migrate/create_acts_as_status_bar.rb"
    end
    
  end      
end
