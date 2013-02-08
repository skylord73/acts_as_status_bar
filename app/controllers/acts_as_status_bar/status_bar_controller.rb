module ActsAsStatusBar
  class StatusBarController < ::ApplicationController

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
  end
end