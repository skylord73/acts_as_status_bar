module ActsAsStatusBar
  class StatusBarController < ::ApplicationController
    @status_bar = params[:id]
    def edit
      respond_to do |format|
        format.html
        format.xml {render :inline => ActsAsStatusBar::StatusBar.to_xml(@status_bar)}
      end
    end
  end
end