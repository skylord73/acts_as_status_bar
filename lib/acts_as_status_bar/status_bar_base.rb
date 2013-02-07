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
        @status_bar_id = nil
        extend ActsAsStatusBar::StatusBarBase::SingletonMethods
        include ActsAsStatusBar::StatusBarBase::InstanceMethods
      end
      
    
    end
    
    # Singleton methods for the mixin
    module SingletonMethods
    end
    
    #Instance methods for the mixin
    module InstanceMethods
      def status_bar_id
        @status_bar_id || _init_status_bar
      end
      
      def status_bar_max=(value)
        ActsAsStatusBar::StatusBar.where(:id => status_bar_id).update_all(:max => value)
      end
      
      def status_bar_max
        ActsAsStatusBar::StatusBar.find(status_bar_id).max
      end
      
      def status_bar_inc(value = 1)
        _update_status_bar(value)
      end
      
      def status_bar_dec(value = 1)
        _update_status_bar(value * -1)
      end
      
      def status_bar_current
        ActsAsStatusBar::StatusBar.find(status_bar_id).current
      end
      
      def status_bar_delete(id)
        ActsAsStatusBar::StatusBar.find(id).delete
      end
      
      private
      
      def _init_status_bar
        @status_bar_id = ActsAsStatusBar::StatusBar.create.id
      end
      
      def _update_status_bar(value)
        status_bar = ActsAsStatusBar::StatusBar.find(status_bar_id)
        status_bar.current = (status_bar.current || 0 ) + value
        status_bar.save
      end
              
    end
    

  end
  
end

require 'active_record'
ActiveRecord::Base.send :include, ActsAsStatusBar::StatusBarBase
