require 'pstore'

module ActsAsStatusBar
  #La classe si basa su PStore, che permette di salvare un hash su file (log/act_as_status_bar.store)
  #==Utilizzo
  #
  #E' possibile instanziare la barra con dei campi aggiuntivi, passati come lista di argomenti
  #e relativi valori di defult
  #new(:id => nil, )
  class StatusBar
    include ActionView::Helpers::DateHelper
    
    #Update frequency in seconds
    FREQUENCY = 10
    #Default End value
    MAX = 100
    #Default storage path
    FILE = "/tmp/acts_as_status_bar.store"
    #Default status bar output when progress is finished
    XML = %q<["Completato", 100, ""]>
    
    # ==CLASS Methods
    class<<self
      #Start Private Class Methods
      
      def delete_all
        store = new
        store.send :_delete_all
      end
      
      #Verifica se la ba barra esiste
      def valid?(id)
        store = new(id)
        store.send(:ids).include?(id)
      end
      
      #Visulaizza tutte le barre nel formato {id => {:max, :current, ...}}
      def all
        store = new
        store.send :_all
      end
      
      def to_s
        store = new
        opt = []
        store.send(:_options).each_key.map{|k| opt << ":#{k}" }
        "#{store.class.name}(#{opt.join(', ')})"
      end
      
      private
      
    end
    
    # ==INSTANCE Methods
    #I paramentri passati hanno la precedenza sui default
    def initialize(*args)
      @options = {  :max => MAX, 
                    :current => 0, 
                    :start_at => nil, 
                    :current_at => 0.0, 
                    :frequency => FREQUENCY,
                    :message => "",
                    :progress => %q<["#{current} (#{percent}%) tempo stimato #{finish_in}", "#{percent}", "#{message}"]> }
      @options.merge!(args.extract_options!)
      @id = @options.delete(:id)
      @id = @id.to_i if @id
      @store = PStore.new(FILE)
      _define_methods
      raise unless valid?
    end
    
    def add_field(field, default=nil)
      _define_method(field.to_sym) unless @options[field.to_sym]
      send("#{field.to_sym}=", default)
    end
    
    #restituisce l'id della barra di stato instanziata
    #o ne crea uno nuovo se non è stato passato
    def id
      @id ||= _new_id
    end
    
    #Verifica se la barra richiesta esiste
    def valid?
      i = id
      ids.include?(i)
    end

    #Cancella la barra
    def delete
      _delete(id)
      @id = nil
      @store = nil
    end
    
    def percent
      (current.to_i * 100 / max.to_i).to_i
    end
    
    #decrementa il valore corrente
    def dec(value=1)
      inc(value*-1)
    end
    
    #incrementa il valore corrente
    #e imposta start_at al tempo corrente se è vuoto
    def inc(value=1) 
      _set(:start_at, Time.now.to_f) unless _get(:start_at)
      _set(:current_at, Time.now.to_f)
      _inc(:current,value)
    end
    
    #Restituisce il tempo stimato di fine attività
    def finish_in
      remaining_time = (current_at.to_f - start_at.to_f)*(max.to_i/current.to_i - 1) if current.to_i > 0
      remaining_time ? distance_of_time_in_words(remaining_time) : "non disponibile"
    end
    
    #restituisce il valore corrente in xml
    #nel formato compatibile con la status bar
    def to_xml
      val = valid? ? eval(progress) : eval(XML)
      Hash['value', val[0], 'percent', val[1], 'message', val[2]].to_xml
    end
    
    private
    
    #restituisce tutti gli id
    def ids
      @store.transaction {@store.roots} if @store
    end
    
    #Cancella tutte le barre
    def _delete_all
      ids.each {|i| _delete(i)}
    end
    
    #Sarebbe carino li ordinasse... ma è una palla!!
    def _all
      out = {}
      ids.each {|i| @store.transaction(true) {out[i] = @store[i]}}
      out
    end
    
    #Crea un nuovo record inizializzando i valori di default con @options
    def _new_id
      @store.transaction do
        @id = @store.roots.sort.last.to_i + 1
      end
      _store_defaults
    end
    
    #Memorizza i valori di default
    def _store_defaults
      i = id
      @store.transaction {@store[i]= @options}
      i
    end
    
    #Incrementa un valore
    #funziona anche con le stringhe
    def _inc(key,value)
      _set(key, (_get(key) || 0) + value)
    end
    
    #Decrementa un valore
    #Non si è usato inc_ key, value*-1 così funziona anche con le stringhe
    #Non è vero ma sarebbe bello!!!
    def _dec(key,value)
      _set(key, (_get(key) || 0) - value)
    end
    
    #salva un valore
    def _set(key,value)
      i = id
      @store.transaction {@store[i][key] = value} if @store
    end
    
    #recupera un valore
    def _get(key)
      i = id
      @store.transaction(true) {@store[i][key]} if @store
    end
    
    #cancella la barra con id
    def _delete(i)
      @store.transaction {@store.delete(i)} if @store
    end
    
    def _options
      @options
    end
    
    #costruisce tutti gli accesso dei metodi in @options
    def _define_methods
      @options.each_key do |method|
        _define_method(method)
      end
    end
    
    #Costruisce gli accessors per il campo passato
    def _define_method(method)
      #Getters
      self.class.send(:define_method, method) do
        _get method.to_sym
      end

      #Setters
      self.class.send(:define_method, "#{method.to_s}=") do |value|
        _set method, value
      end

      #Incrementer
      self.class.send(:define_method, "inc_#{method.to_s}") do |*args|
        value = args.first || 1
        _inc method, value
      end

      #Decrementer
      self.class.send(:define_method, "dec_#{method.to_s}") do |*args|
        value = args.first || 1
        _dec method, value
      end
    end
    
    
  end
end
