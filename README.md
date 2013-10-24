=ActsAsStatusBar
ActsAsStatusBar adds status bar functionality to your ActiveRecord Models.
I tried to keep it very simple, but powerful enough to be very useful.

You will need Prototype to run your gem.

==Setup
Add this line to your application's Gemfile:
 gem 'acts_as_status_bar'

then execute:
 $ bundle install

or install it yourself as:
 $ sudo gem install acts_as_status_bar

install addon:
 $ rails g acts_as_status_bar:install

==Usage
Let's imagine you have a Home model, with a controller and a view...

In your model:

```ruby 
#app/models/home.rb
class Home < ActiveRecord::Base
 	acts_as_status_bar
  
	def my_very_long_task_needing_a_status_bar
		status_bar_init
		status_bar.max=10000
		status_bar.message="My very long task..."
			10000.times do
				status_bar.inc
			end
	end
end

```	

In your controller:
 
```ruby
#app/controllers/homes_controller.erb
def create
  @home = Home.new(params[:home])
	status_bar_init(@home) do
	  @home.save!
  end
end

```

In your view:

```erb
#app/views/home/index.html.erb 
<%= status_bar_for(@home) %>

<%= form_for(@home) do |f| %>
  ...
	<%= f.hidden_field :status_bar_id %>
	<%= f.submit :onclick => 'status_bar_init()' %>
<% end %> 

```

Please note that the status_bar_for helper MUST be before the form_for with the hidden field.
(The helper creates the bar id, but form_for copies the object so it is not possibile to update by reference...)

Or, if you don't have an object,
```erb
  <%= status_bar_tag %>
  <%=link_tag "MyLink", my_url, :onclick => 'status_bar_init()' %>

```

==Functions
StatusBar uses an external store (PStore) to archive progress data, so all you need to use it
is the id of the status bar you are using.

This id is stored in your model status_bar_id attribute.

You need to pass it back to your controller's "create" actions using an hidden field.

When you call status_bar_init from your model the status_bar_id is valorized, so your status_bar
is created, with the same id of your js.

Only one id is passed and the magic is done!

There are some functions you can use in your model to customize the behavior of the bar.
===Basic
* status_bar_init
	 Initializes the bar using the id in status_bar_id, or creates a new one if not defined.
* status_bar.inc(value=1)
	 Increments counter by 1 or by value.
*	status_bar.dec(value=1)
	 Decrements counter by 1 or by value.
* status_bar.max=(value)
	 Sets the max value, that, once reached, stops the bar.
* status_bar.message=(value)
	 Set the message in the first line of the bar: you can use it to display dynamic messages
	 during the process.
* status_bar.delete
   Deletes the current status bar.
   Do not forget it or you will be submerged of useless inactive status bars...
	
===Advanced
* status_bar.progress=(value)
   Default value is : %q<["#{current}/#{max} (#{percent}%) tempo stimato #{finish_in}", "#{percent}", "#{message}"]>
   The string is evaluated and passed to the js as xml.
 You can customize the first and the last fields, while the second (percentage) is used for the visual bar and to
 stop the bar when 100 is reached.
 You can see the code to get the usable fields.
* status_bar.add_field(:field)
   Adds a new field to the status bar, you can use to store data or to customize the output.
   New methods are created dinamically to access your new field:
 * inc_field
 * dec_field
 * field=(value)
 * field
* ActsAsStatusBar::StatusBar.delete_all
   Deletes all bars stored.
* ActsAsStatusBar::StatusBar.all
	 Return all active status bars.
* ActsAsStatusBar::StatusBar.valid?(id)
	 Checks if the id passed corresponds to a valid status bar.
==Administration
Some times you will need to maintain the status bar storage.

You can link to acts_as_status_bar_status_bar_index_path .

The controller lets you check and delete stored status bars.

You can access the bar info pointing to acts_as_status_bar_status_bar_path(id) or,
if you need a more structured info, to acts_as_status_bar_status_bar(id, :format => :xml)

==Styling
You can change the bar style in the acts_as_status_bar.css .

==Whislist
* finding time to create tests...

==Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Added some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

==Thanks

*	Michele Ferretti, who created the original AjaxProgressBar (http://www.blackbirdblog.it/blog/archivio/2006/03/09/ajax-progress-bar/)
