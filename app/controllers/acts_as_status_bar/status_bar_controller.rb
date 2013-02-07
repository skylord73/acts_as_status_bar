module ActsAsStatusBar
  class StatusBarController < ::ApplicationController

    def edit
      @status_bar = ActsAsStatusBar::StatusBar.find(session,params[:id])
      respond_to do |format|
        format.html
        format.xml {render :inline => @status_bar.to_xml}
      end
    end
  end
end