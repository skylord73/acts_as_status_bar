module ActsAsStatusBar
  class StatusBar
    
    # ==CLASS Methods
    class<<self
      #Start Private Class Methods
      
      #Instanzia una nuova barra con id 
      def find(session,id)
        new(session,id)
      end
      
      private
      
    end
    
    # ==INSTANCE Methods
    def initialize(session, session_id = nil)
      @session = session
      @id = session_id
      mylog("initialize: #{@session.inspect}")
      session[:acts_as_status_bar] ||= {}
      session[:acts_as_status_bar][id] ||= {}
      session[:acts_as_status_bar][id][:id] = id
    end
    
    #Inizializza utilzzando un'altra status bar
    def status_bar=(sb)
      self.status_bar = sb
      self.status_bar_id = sb.id
    end
    
    #Cancella la barra con id
    def delete
      session[:acts_as_status_bar].delete(@id)
    end
    
    def status_bar
      @session[:acts_as_status_bar][id]
    end
    
    def set_max(value)
      status_bar[:max]= value
    end

    def max
      status_bar[:max]
    end
    
    def current
      status_bar[:current]
    end
    
    def dec(value=1)
      inc(value*-1)
    end
    
    def inc(value=1)
      status_bar[:current] = (status_bar[:current] || 0) + value 
    end
    
    def to_xml
      Hash['value', status_bar[:current]].to_xml
    end
    
    #Bisognerà costruire id con session + random number, altrimenti non posso avere due progress
    #sulla stessa sessione
    def id
      @id ||= @session[:session_id]
    end
    
    private
    
  end
end
