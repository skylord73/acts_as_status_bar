#Add here view and controller helpers
module ActsAsStatusBarHelper
  # Scrive html script tag del costruttore della progress bar
  def status_bar(id)
    #mylog("ProgressBarHelper/progress_bar - :#{url.inspect} - #{total.inspect}")
    url = edit_acts_as_status_bar_status_bar_path(id, :format => :xml)
    status_bar = ActsAsStatusBar::StatusBar.find(session,id)
    total = ActsAsStatusBar::StatusBar.max(status_bar)
    content_tag(:div, :id => "progress-bar-container", :align => 'center') do
      content_tag(:p) do
        concat I18n.t(:label, :scope => :progress_bar)
        concat content_tag(:a,'',:id => 'progress-value')
        concat total.nil? ? "%" : "/#{total}"
      end +
      content_tag(:div,
        content_tag(:div,'', :id => "bar"),
      :id => "progress-bar", :align => 'left')
    end +
    javascript_tag(%Q[
      function init(){
        var progress = new AjaxProgressBar('progress-bar-container','progress-bar', 'bar', {
          frequency: 3,
          total: #{total || 100},
          url: "#{url}"
        });
        progress.start();
      }
    ])
  end
end

