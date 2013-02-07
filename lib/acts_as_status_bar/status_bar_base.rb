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
        ActsAsStatusBar::StatusBar.new
      end
      
      def status_bar_delete(session, id)
        ActsAsStatusBar::StatusBar.delete(session, id)
      end
      
      def status_bar_current(id)
        ActsAsStatusBar::StatusBar.current(id)
      end
    end
    
    #Instance methods for the mixin
    module InstanceMethods
      
      def status_bar_set_max(id,value)
        ActsAsStatusBar::StatusBar.set_max(id, value)
      end
      
      def status_bar_max(id)
        ActsAsStatusBar::StatusBar.max(id)
      end
      
      def status_bar_inc(id, value = 1)
        ActsAsStatusBar::StatusBar.inc(id, value)
      end
      
      def status_bar_dec(id, value = 1)
        ActsAsStatusBar::StatusBar.inc(id, value * -1)
      end
      
      private
              
    end
    

  end
  
end

require 'active_record'
ActiveRecord::Base.send :include, ActsAsStatusBar::StatusBarBase
