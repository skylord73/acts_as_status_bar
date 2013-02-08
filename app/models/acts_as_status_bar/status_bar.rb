require 'pstore'

module ActsAsStatusBar
  #La classe si basa su PStore, che permette di salvare un hash su file (log/act_as_status_bar.store)
  class StatusBar
    
    # ==CLASS Methods
    class<<self
      #Start Private Class Methods
      
      def delete_all
        store = new
        store.send :_delete_all
      end
      
      #Visulaizza tutte le barre nel formato {id => {:max, :current, ...}}
      def all
        store = new
        store.send :_all
      end
      
      private
      
    end
    
    # ==INSTANCE Methods
    def initialize(session_id = nil)
      @store = PStore.new("/tmp/acts_as_status_bar.store")
      @id = session_id
      @id = @id.to_i if @id
      mylog("initialize: #{@store.inspect}")
    end
    
    #restituisce l'id della barra di stato instanziata
    def id
      @id ||= _new_id
    end
    
    #Cancella la barra
    def delete
      _delete(id)
      @id = nil
      @store = nil
    end
    
    #Imposta il fondo scala
    def max=(value)
      mylog("max: value=#{value}")
      _set :max, value
    end

    #legge il fondo scala
    def max
      _get(:max)
    end
    
    #legge il valore corrente
    def current
      _get(:current) || 0
    end
    
    #decrementa il valore corrente
    def dec(value=1)
      inc(value*-1)
    end
    
    #incrementa il valore corrente
    def inc(value=1)
      _set(:current, (_get(:current) || 0) + value) 
    end
    
    def finish_in
      ((_get(:current_at) || 0) - (_get(:start_at) || 0))/current*(max || 0)
    end
    #restituisce il valore corrente in xml
    #nel formato comatibile con la status bar
    def to_xml
      Hash['value', _get(:current)].to_xml
    end
    
    private
    
    #restituisce tutti gli id
    def ids
      @store.transaction {@store.roots} if @store
    end
    
    def _delete_all
      ids.each {|i| _delete(i)}
    end
    
    #Sarebbe carino li ordinasse... ma è una palla!!
    def _all
      out = {}
      ids.each {|i| @store.transaction(true) {out[i] = @store[i]}}
      out
    end
    
    def _new_id
      out = nil
      @store.transaction do
        out = (@store.roots.sort.last || 0) + 1
        @store[out] = {:max => nil, :current => nil, :start_at => Time.now.to_f, :current_at => nil }
      end if @store
      out
    end
    
    def _set(key,value)
      i = id
      @store.transaction {@store[i][:current_at] = Time.now.to_f; @store[i][key] = value} if @store
    end
    
    def _get(key)
      i = id
      @store.transaction(true) {@store[i][key]} if @store
    end
    
    def _delete(i)
      @store.transaction {@store.delete(i)} if @store
    end
    
  end
end
