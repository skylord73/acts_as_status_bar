require 'pstore'

module ActsAsStatusBar
  #StatusBar is used to support a dynamic status bar, with values, percentage, timing and messages.
  #==Usage
  #
  #It is possible to instantiate the bar with additional fields, passed as a list of arguments and their relative default values.
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
      #Start Public Class Methods
      #NO BAR is created using Class Methods
      
      #Deletes all bars
      def delete_all
        store = new
        store.send :_delete_all
      end
      

      #Checks if the bar is valid
      def valid?(id)
        store = new
        store.send(:ids).include?(id.to_i)
      end
      
      #It returns all active bars
      #===Format
      # {id1 => {:max, :current, ...}
      #  id2 => {:max, :current, ...}
      # }
      def all
        store = new
        store.send :_all
      end
      
      #to_s
      def to_s
        store = new
        opt = []
        store.send(:_options).each_key.map{|k| opt << ":#{k}" }
        "#{store.class.name}(#{opt.join(', ')})"
      end
      
      # Start Private Class Methods
      private
      
    end
    
    # ==INSTANCE Methods
    
    #Initializes the bar
    #===Options
    #*  no_options        #Initializes the bar with a new id and doesn't store defaults
    #*  :id => id         #Initializes the bar with a specific id and stores defaults if new_record?
    #*  :create => false  #Initializes the bar with a specific id (if present), without storing defaults
    def initialize(*args)
      @options = {  :max => MAX, 
                    :current => 0, 
                    :start_at => nil, 
                    :current_at => 0.0, 
                    :message => "",
                    :progress => %q<["#{current}/#{max} (#{percent}%) tempo stimato #{finish_in}", "#{percent}", "#{message}"]> }
      @options.merge!(args.extract_options!)
      @id = @options.delete(:id)
      #id usually comes from params, so it must be sure it is converted to int
      @id = @id.to_i if @id
      @store = PStore.new(FILE)
      _init_bar if @id
    end
    
    #Adds a new field to the bar and stores default value
    #(Store Data)
    def add_field(field, default=nil)
      _define_method(field.to_sym) unless @options[field.to_sym]
      send("#{field.to_sym}=", default)
    end
    
    #Gets or creates an id
    def id
      @id ||= Time.now.utc.to_i
    end
    
    #Checks if the bar is new or already existent
    def valid?
      ids.include?(@id)
    end

    #Destroys the bar and returns its last values
    def delete
      out = _delete(id) if @store
      @id = nil
      @store = nil
      out
    end
    
    def percent
      raise CustomError::InvalidBar unless valid?
      (current.to_i * 100 / max.to_i).to_i if valid?
    end
    
    #Decrements current value
    def dec(value=1)
      inc(value*-1)
    end
    
    #Increments current value and sets start_at at current time if not set yet
    #e imposta start_at al tempo corrente se è vuoto
    def inc(value=1) 
      raise CustomError::InvalidBar unless valid?
      _set(:start_at, Time.now.to_f) unless _get(:start_at)
      _set(:current_at, Time.now.to_f)
      _inc(:current,value)
    end
    
    #Returns default frequency value, if not passed in the helper
    def frequency
      FREQUENCY
    end
    
    #Returns estimated completion time
    def finish_in
      raise CustomError::InvalidBar unless valid?
      remaining_time = (current_at.to_f - start_at.to_f)*(max.to_f/current.to_f - 1.0) if current.to_i > 0
      remaining_time ? distance_of_time_in_words(remaining_time) : "non disponibile"
    end
    
    #Returns current value in xml in a format compatible with the status bar
    def to_xml
      val = valid? ? eval(progress) : eval(XML)
      Hash['value', val[0], 'percent', val[1], 'message', val[2]].to_xml
    end
     
    private
    
    #Initializes the bar, stores defaults and dinamycally creates methods
    def _init_bar
      unless @options.delete(:create)
        _store_defaults
        _define_methods
      end
    end
    
    #Returns all ids
    def ids
      @store.transaction {@store.roots}
    end
    
    #Deletes the bar marked with a specific id
    def _delete(i)
      out ={}
      @store.transaction {out = @store.delete(i)}
      out
    end
    
    #Deletes all bars
    def _delete_all
      ids.each {|i| _delete(i)}
    end
    
    #Returns all status bars
    def _all
      out = {}
      ids.each {|i| @store.transaction(true) {out[i] = @store[i]}}
      out
    end
    

    #Increments a value
    #It also works with strings
    def _inc(key,value)
      _set(key, (_get(key) || 0) + value)
    end
    
    #Decrements a value
    #inc_ key, value*-1 was not used so that i can also work with strings
    #[Not implemented yet... It would be a nice thing to add in the future...]
    def _dec(key,value)
      _set(key, (_get(key) || 0) - value)
    end
    
    #Saves a value
    def _set(key,value)
      @store.transaction {@store[@id][key] = value}
    end
    
    #Retrieves a value
    def _get(key)
      @store.transaction(true) {@store[@id][key]}
    end
    
    #Returns options
    def _options
      @options
    end
    
    #Stores default values if the bar is not created yet
    def _store_defaults
      @store.transaction {@store[@id]= @options} unless valid?
    end

    #Builds accessor methods for every bar's attribute
    def _define_methods
      @store.transaction(true){@store[@id]}.each_key do |method|
        _define_method(method)
      end
    end
    
    #Build acessors for a specific attribute
    #===Accessors
    #*  inc_attribute(value=1)
    #*  dec_attribute(value=1)
    #*  attribute
    #*  attribute=(value)
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
