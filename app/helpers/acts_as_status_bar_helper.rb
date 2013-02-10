module ActsAsStatusBarHelper
  #Use it in your views to activate status bars
  #You can put it everywhere in your view, you only need to pass it your object
  #
  #The only other think you need to do is to add an :onclick => 'status_bar_init()'
  #to the button/link that activate the bar:
  #
  # => <%= f.submit :onclick => 'status_bar_init()' %>
  #
  #You can access to the admin page by the helper:
  # => acts_as_status_bar_status_bar_index_path
  #
  def status_bar_for(object)
    status_bar = ActsAsStatusBar::StatusBar.new(:id => object.status_bar_id)
    mylog("status_bar:  id:#{id.inspect}  status_bar#{status_bar.inspect}")
    url = acts_as_status_bar_status_bar_path(id, :format => :xml)
    frequency = status_bar.frequency
    stylesheet_link_tag('acts_as_status_bar')+
    content_tag(:div, :id => "acts-as-status-bar-container", :align => 'center') do
      content_tag(:p, '', :id => 'acts-as-status-bar-message') +
      content_tag(:p, '', :id => 'acts-as-status-bar-value') +
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
          'acts-as-status-bar-value',
          'acts-as-status-bar-progress-bar',
          'acts-as-status-bar', {
          frequency: #{frequency},
          total: 100,
          url: "#{url}"
        });
        progress.start();
      }
    ])
    
  end
end

