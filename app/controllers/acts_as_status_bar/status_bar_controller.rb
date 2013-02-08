module ActsAsStatusBar
  class StatusBarController < ::ApplicationController
    def index
      @status_bars=ActsAsStatusBar::StatusBar.all
    end
    
    def edit
      @status_bar = ActsAsStatusBar::StatusBar.new(params[:id].to_i)
      mylog("edit: status_bar:#{@status_bar.inspect}")
      mylog("edit1: ids:#{@status_bar.ids.inspect}")
      mylog("edit3: max:#{@status_bar.max.inspect}")
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