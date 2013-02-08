require 'pstore'

module ActsAsStatusBar
  #La classe si basa su PStore, che permette di salvare un hash su file (log/act_as_status_bar.store)
  class StatusBar
    include ActionView::Helpers::DateHelper
    
    FREQUENCY = 10
    MAX = 100
    TYPE = :percent
    
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
      _set :max, value
    end

    #legge il fondo scala
    def max
      _get(:max) || MAX
    end
    
    #legge il valore corrente
    def current
      _get(:current).to_i
    end
    
    def start_at
      _get(:start_at) || 0
    end
    
    def current_at
      _get(:current_at) || 0
    end
    
    def frequency
      _get(:frequency) || FREQUENCY
    end
    
    def percent
      (current * 100 / max).to_i
    end
    
    #decrementa il valore corrente
    def dec(value=1)
      inc(value*-1)
    end
    
    #incrementa il valore corrente
    #e imposta start_at al tempo corrente se è vuoto
    def inc(value=1) 
      _set(:start_at, Time.now.to_f) unless _get(:start_at)
      _set(:current, current + value)
    end
    
    #Restituisce il tempo stimato di fine attività
    def finish_in
      distance_of_time_in_words((current_at - start_at)/current* max) 
    end
    
    #restituisce il valore corrente in xml
    #nel formato comatibile con la status bar
    #:type => :percent  #Normalizza i valori a 100
    def to_xml
      val = case type
        when :percent then ["#{current} (#{percent}%) tempo stimato #{finish_in}", percent]
      else
        ["#{current}/#{max} tempo stimato #{finish_in}", percent]
      end 
      Hash['value', val[0], 'percent', val[1]].to_xml
    end
    
    private
    
    def type
      _get(:type) || TYPE
    end
    
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
        @store[out] = { :max => MAX, 
                        :current => nil, 
                        :start_at => nil, 
                        :current_at => nil, 
                        :frequency => FREQUENCY,
                        :type => TYPE }
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
