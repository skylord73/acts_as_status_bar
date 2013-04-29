module ActsAsStatusBar
  class StatusBarController < ::ApplicationController
    def index
      @status_bars=ActsAsStatusBar::StatusBar.all
    end
    
    def show
      @status_bar = ActsAsStatusBar::StatusBar.new(:id => params[:id], :create => false)
      respond_to do |format|
        format.html
        format.xml {render :inline => @status_bar.to_xml}
      end 
#    rescue => e
#      flash[:alert] = e.message
#      redirect_to :action => 'show', :controller => 'status_bar'
    end
    
    def destroy
      @status_bar = ActsAsStatusBar::StatusBar.new(:id => params[:id], :create => false)
      @status_bar.delete
      redirect_to :action => "index"
    end
    
    def destroy_all
      ActsAsStatusBar::StatusBar.delete_all
      redirect_to :action => "index"
    end
  end
end