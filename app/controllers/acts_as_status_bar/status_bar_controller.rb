module ActsAsStatusBar
  class StatusBarController < ::ApplicationController
    def edit
      @status_bar = ActsAsStatusBar::StatusBar.find(params[:id])
      respond_to do |format|
        format.html
        format.xml {render :inline => @status_bar.to_status_bar}
      end
    end
  end
end