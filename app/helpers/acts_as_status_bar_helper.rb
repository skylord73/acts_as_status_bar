#Add here view and controller helpers
module ActsAsStatusBarHelper
  # Scrive html script tag del costruttore della progress bar
  def status_bar(id)
    status_bar = ActsAsStatusBar::StatusBar.new(id)
    mylog("status_bar:  id:#{id.inspect}  status_bar#{status_bar.inspect}")
    url = acts_as_status_bar_status_bar_path(id, :format => :xml)
    total = status_bar.percent
    frequency = status_bar.frequency
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
    javascript_include_tag("acts_as_status_bar_javascript") +
    javascript_tag(%Q[
      function status_bar_init(){
        var progress = new ActsAsStatusBar('progress-bar-container','progress-bar', 'bar', {
          frequency: #{frequency},
          total: #{total},
          url: "#{url}"
        });
        progress.start();
      }
    ])
    
  end
end

