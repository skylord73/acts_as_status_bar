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
      
      def status_bar_init
        self.status_bar = ActsAsStatusBar::StatusBar.new(self.status_bar_id)
        self.status_bar_id = self.status_bar.id
        mylog("status_bar_init: status_bar#{self.status_bar.inspect}, status_bar_id:#{self.status_bar_id}")
      end
      
      def status_bar=(sb)
        @status_bar = sb
        @status_bar_id = sb.id
      end
      
      private
              
    end
    

  end
  
end

require 'active_record'
ActiveRecord::Base.send :include, ActsAsStatusBar::StatusBarBase
