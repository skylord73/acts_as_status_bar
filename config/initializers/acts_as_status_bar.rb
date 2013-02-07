#Il caricamento dellce costanti, poichè dipende dalla classe Enumeration, definita dall'applicazione Rails
#non può essere fatto nell'engine in quanto Rails.root non è definito....
require "acts_as_status_bar/constant" if File.exists?("acts_as_status_bar/constant.rb")
require "acts_as_status_bar/exceptions" if File.exists?("acts_as_status_bar/exceptions.rb")
