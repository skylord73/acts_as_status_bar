require 'rails/generators'
module ActsAsStatusBar
  class InstallGenerator < Rails::Generators::Base
    desc "Install generator for ActsAsStatusBar gem"
    source_root File.expand_path("../templates", __FILE__)
    
    def copy_config
      directory "."
    end
    
    #def copy_public
    #  directory "public"
    #end
    
  end      
end

