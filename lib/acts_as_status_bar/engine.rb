module ActsAsStatusBar
  class Engine < Rails::Engine
    
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    initializer 'acts_as_status_bar.helper' do |app|
      ActiveSupport.on_load(:action_controller) do
        include ActsAsStatusBarHelper
      end
      ActiveSupport.on_load(:action_view) do
        include ActsAsStatusBarHelper
      end
     
    end
  end
  
end

#Add ere require to specific file or gem used
