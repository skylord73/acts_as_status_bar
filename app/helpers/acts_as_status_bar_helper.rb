#Add here view and controller helpers
module ActsAsStatusBarHelper
  # Scrive html script tag del costruttore della progress bar
  def status_bar(id)
    status_bar = ActsAsStatusBar::StatusBar.new(id)
    mylog("status_bar:  id:#{id.inspect}  status_bar#{status_bar.inspect}")
    url = acts_as_status_bar_status_bar_path(id, :format => :xml)
    total = status_bar.percent
    frequency = status_bar.frequency
    stylesheet_link_tag('acts_as_status_bar')+
    content_tag(:div, :id => "acts-as-status-bar-container", :align => 'center') do
      content_tag(:p, '', :id => 'acts-as-status-bar-message') +
      content_tag(:div,
        content_tag(:div,'', :id => "acts-as-status-bar"),
        :id => "acts-as-status-bar-progress-bar", :align => 'left'
      )
    end +
    javascript_include_tag("acts_as_status_bar_javascript") +
    javascript_tag(%Q[
      function status_bar_init(){
        var progress = new ActsAsStatusBar(
          'acts-as-status-bar-container',
          'acts-as-status-bar-message', 
          'acts-as-status-bar-progress-bar',
          'acts-as-status-bar', {
          frequency: #{frequency},
          total: #{total},
          url: "#{url}"
        });
        progress.start();
      }
    ])
    
  end
end

