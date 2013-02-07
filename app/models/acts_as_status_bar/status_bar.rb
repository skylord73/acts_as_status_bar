module ActsAsStatusBar
  class StatusBar
    
    # ==CLASS Methods
    class<<self
      #Start Private Class Methods
      
      def delete(session, status_bar)
        session[:acts_as_status_bar].delete(status_bar[:id])
      end
      
      def current(status_bar)
        status_bar[:current]
      end
      
      def set_max(status_bar, value)
        status_bar[:max]= value
      end

      def max(status_bar)
        status_bar[:max]
      end

      def inc(status_bar, value)
        status_bar[:current] = (status_bar[:current] || 0) + value 
      end

      def to_xml(status_bar)
        Hash['value', status_bar[:current]].to_xml
      end
      
      def find(session,id)
        session[:acts_as_status_bar][id]
      end
      
      private
      
    end
    
    # ==INSTANCE Methods
    def initialize(session)
      @session = session
      mylog("initialize: #{@session.inspect}")
      session[:acts_as_status_bar] ||= {}
      session[:acts_as_status_bar][id] ||= {}
      session[:acts_as_status_bar][id][:id] = id
    end
    
    def status_bar
      @session[:acts_as_status_bar][id]
    end
    
    private
    
    def id
      @session[:session_id]
    end
    
    
  end
end
