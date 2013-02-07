module ActsAsStatusBar
  class StatusBar < ActiveRecord::Base
    set_table_name "acts_as_status_bar"
    
    def to_status_bar
      Hash['value', self.current].to_xml
    end
  end
end
