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
        attr_accessor :status_bar
        extend ActsAsStatusBar::StatusBarBase::SingletonMethods
        include ActsAsStatusBar::StatusBarBase::InstanceMethods
      end
      
    
    end
    
    # Singleton methods for the mixin
    module SingletonMethods
      
    end
    
    #Instance methods for the mixin
    module InstanceMethods
      
      def status_bar_init(session)
        status_bar = ActsAsStatusBar::StatusBar.new(session, status_bar_id)
        status_bar_id = status_bar.id
      end
      
      def status_bar_delete
        status_bar.
      end
      
      def status_bar_set_max(value)
        status_bar.set_max(value)
      end
      
      def status_bar_max
        status_bar.max
      end
      
      def status_bar_inc(value = 1)
        status_bar.inc(value)
      end
      
      def status_bar_dec(id, value = 1)
        status_bar.inc(value * -1)
      end
      
      private
              
    end
    

  end
  
end

require 'active_record'
ActiveRecord::Base.send :include, ActsAsStatusBar::StatusBarBase
