module ActsAsStatusBarHelper
  #Use it in your views to activate status bars.
  #You can put it everywhere in your view, you only need to pass it your object.
  #
  #The only other thing you need to do is to add an :onclick => 'status_bar_init()'
  #to the button/link that activates the bar:
  #
  # => <%= f.submit :onclick => 'status_bar_init()' %>
  #
  #You can access to the admin page via the helper:
  # => acts_as_status_bar_status_bar_index_path
  
  #Use it if you don't have an object.
  #Id is passed to the controller via session[:acts_as_status_bar][:id]
  #and can be retrieved using status_bar_id(params) in your controller
  # => #app/views/home/index.html.erb
  # => <%= status_bar_tag %>
  # => <%= link_to 'my_link', my_link_action_path, :onclick => 'status_bar_init()' %>
  #
  # => #app/controllers/homes_controller.erb
  # => def action
  # =>  @home = Home.new
  # =>  @home.status_bar_id = status_bar_id(params)
  # =>  @home.do_what_I_need
  # =>  @home.status_bar.delete
  # => end
  def status_bar_tag(frequency = nil)
    status_bar = ActsAsStatusBar::StatusBar.new
    frequency = frequency || status_bar.frequency
    url = acts_as_status_bar_status_bar_path(status_bar.id, :format => :xml)
    session[:acts_as_status_bar]={:id => status_bar.id}
    _status_bar_init(frequency, url)
  end
  
  #Use with status_bar_ta, in controller to initialize and destroy bar
  # => @home = Home.find(params[:id])
  # => status_bar_init(@home) do
  #     @home.destroy
  # => end
  #
  def status_bar_init(object, &block)
    object.status_bar_id = status_bar_id(params)
    object.status_bar_init
    bar = object.status_bar
    yield block
    bar.delete
  end
  
  #Used to retrive id from params in controller
  def status_bar_id(params)
    session[:acts_as_status_bar].try(:fetch, :id)
  end
  
  #Use it if you have an Object and a form to pass parameters to the controller.
  #The helper populates object.status_bar_id, and you need an hidden field in your form
  #to pass the id to your object in the controller:
  # => #app/views/home/index.html.erb
  # => <%= status_bar_for(@home) %>
  # => <%= form_for(@home) do |f| %>
  # =>  ...
  # =>  <%= f.hidden_field :status_bar_id %>
  # =>  <%= f.submit :onclick => 'status_bar_init()' %>
  # => <% end %>
  def status_bar_for(object,frequnecy = nil)
    object.status_bar_init
    url = acts_as_status_bar_status_bar_path(object.status_bar_id, :format => :xml)
    frequency = frequency || object.status_bar.frequency
    _status_bar_init(frequency, url)
  end
  
  private
  
  #Initialize the status bar
  def _status_bar_init(frequency, url)
    stylesheet_link_tag('acts_as_status_bar')+
    content_tag(:div, :id => "acts-as-status-bar-container", :align => 'center') do
      content_tag(:p, '...', :id => 'acts-as-status-bar-message') +
      content_tag(:p, '...', :id => 'acts-as-status-bar-value') +
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

