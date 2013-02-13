#Localize messages in it.CustomError.MyError
module ActsAsStatusBar
  class CustomError < StandardError
    def initialize(*args)
        @options = args.extract_options!
        super
    end
      
    def message
      @options.merge!({:default => "Error : #{@options.inspect}"})
      I18n.t("#{self.class.name.gsub(/::/,'.')}", @options )
    end
    
    class InvalidBar < CustomError; end
    
  end 
end

