module ActsAsStatusBar
  class StatusBarController < ::ApplicationController
    def index
      @status_bars=ActsAsStatusBar::StatusBar.all
    end
    
    def show
      @status_bar = ActsAsStatusBar::StatusBar.new(:id => params[:id]) if ActsAsStatusBar::StatusBar.valid?(params[:id])
      respond_to do |format|
        format.html
        format.xml {render :inline => ActsAsStatusBar::StatusBar.valid?(params[:id]) ? @status_bar.to_xml : ActsAsStatusBar::StatusBar.to_xml}
      end
    end
    
    def destroy
      @status_bar = ActsAsStatusBar::StatusBar.new(:id => params[:id]) if ActsAsStatusBar::StatusBar.valid?(params[:id])
      @status_bar.delete
      redirect_to :action => "index"
    end
    
    def destroy_all
      ActsAsStatusBar::StatusBar.delete_all
      redirect_to :action => "index"
    end
  end
end