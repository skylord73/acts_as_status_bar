module ActsAsStatusBar
  class StatusBarController < ::ApplicationController
    def index
      @status_bars=ActsAsStatusBar::StatusBar.all
    end
    
    def show
      @status_bar = ActsAsStatusBar::StatusBar.new(params[:id].to_i)
      mylog("show: #{@status_bar.to_xml.inspect}", "DEBUG", :CYAN)
      respond_to do |format|
        format.html
        format.xml {render :inline => @status_bar.to_xml}
      end
    end
    
    def destroy
      @status_bar = ActsAsStatusBar::StatusBar.new(params[:id].to_i)
      @status_bar.delete
      redirect_to :action => "index"
    end
    
    def destroy_all
      ActsAsStatusBar::StatusBar.delete_all
      redirect_to :action => "index"
    end
  end
end