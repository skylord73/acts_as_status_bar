require 'rails/generators'
require 'rails/generators/migration'
require 'templates/my_seed'

module ActsAsStatusBar
  class SeedGenerator < Rails::Generators::NamedBase
    desc "Seeding generator for WebgatecAmministrazione gem"
    argument :env, :type => :string, :default => "development", :banner => "Ambiente in cui caricare i dati"
    
    def seed
      puts "Seeding #{env} database..."
      Seed.populate(env)
    end
    
    #def copy_public
    #  directory "public"
    #end
    
  end      
end
