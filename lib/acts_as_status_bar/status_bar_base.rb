module ActsAsStatusBar
  module StatusBarBase
    def self.included(base) # :nodoc:
      base.send :extend, ClassMethods
    end
    
    # Class methods for the mixin
    module ClassMethods
      # defines the class method to inject monitor methods
      #
      #==Example
      # class MyModel < ActiveRecord::Base
      #   acts_as_monitor
      #   ...
      #   private
      #
      #   def warn_test?
      #     whatever you want that return true in a warning condition
      #   end
      #
      #   def error_test?
      #     whatever you want that return true in an error condition
      #   end
      def acts_as_status_bar(options={})
        attr_accessor :status_bar_id
        extend ActsAsStatusBar::StatusBarBase::SingletonMethods
        include ActsAsStatusBar::StatusBarBase::InstanceMethods
      end
      
    
    end
    
    # Singleton methods for the mixin
    module SingletonMethods
      def status_bar_init
        ActsAsStatusBar::StatusBar.create.id
      end
      
      def status_bar_delete(id)
        ActsAsStatusBar::StatusBar.find(id).delete
      end
      
      def status_bar_current(id)
        ActsAsStatusBar::StatusBar.find(id).current
      end
    end
    
    #Instance methods for the mixin
    module InstanceMethods
      
      def status_bar_set_max(id,value)
        ActsAsStatusBar::StatusBar.where(:id => id).update_all(:max => value)
      end
      
      def status_bar_max(id)
        ActsAsStatusBar::StatusBar.find(id).max
      end
      
      def status_bar_inc(id, value = 1)
        _update_status_bar(id, value)
      end
      
      def status_bar_dec(id, value = 1)
        _update_status_bar(id, value * -1)
      end
      
      private
    
      def _update_status_bar(id, value)
        status_bar = ActsAsStatusBar::StatusBar.find(id)
        status_bar.current = (status_bar.current || 0 ) + value
        status_bar.save
      end
              
    end
    

  end
  
end

require 'active_record'
ActiveRecord::Base.send :include, ActsAsStatusBar::StatusBarBase
