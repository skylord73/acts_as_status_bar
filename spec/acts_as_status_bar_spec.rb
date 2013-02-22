require 'spec_helper'

#########################################

#Defines a model class which implements the status bar gem.
class MyClass < ActiveRecord::Base
  
  # Helper which makes all the status_bar functions available.
  acts_as_status_bar
  
  before_destroy :clear_bar
  
  MAX = 100
  
  def save
  end
  
  def initialize(*args)
    @options = args.extract_options!
    @status_bar_id = options[:id] if params[id]
    status_bar_init(@status_bar_id)
    # super
  end
  
  def destroy
    status_bar_init(self)
    bar = status_bar_init(self) do
      self.save
    end  
  end
  
  def clear_bar
    status_bar_init(self)
    status_bar.message = "Deleting..."
    status_bar.max = MAX
  end
end

#########################################

describe ActsAsStatusBar do
  it "should be valid" do
    ActsAsStatusBar.should be_a(Module)
  end
end

describe ActsAsStatusBar::StatusBar do

  let(:status_bar) { ActsAsStatusBar::StatusBar.new(:id => 1) }
  let(:object) { MyClass.new(:status_bar_id => status_bar.id) }
  
  it "should be valid" do
    ActsAsStatusBar::StatusBar.should be_a(Class)
    status_bar.should be_valid
  end
  
  it "should be assigned correctly" do
    object.save
    puts "\n\n\n status_bar.inspect = #{status_bar.inspect}"
    puts "\n\n\n object.status_bar.inspect = #{object.status_bar.inspect}"
    object.status_bar.should equal(status_bar)
  end

  # it "should assign the right id to #status_bar_id method" do
    # object.status_bar_id.should equal(object.status_bar.id)
  # end
  
  # it "should be destroyed by destroying the parent object" do
    # object.destroy!.should be_true, object.errors
    # object.status_bar.should be nil
  # end
end
