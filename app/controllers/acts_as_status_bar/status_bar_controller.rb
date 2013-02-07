module ActsAsStatusBar
  class StatusBarController < ::ApplicationController

    def edit
      @status_bar = ActsAsStatusBar::StatusBar.find(session,params[:id])
      respond_to do |format|
        format.html
        format.xml {render :inline => ActsAsStatusBar::StatusBar.to_xml(@status_bar)}
      end
    end
  end
end