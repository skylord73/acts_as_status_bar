require 'spec_helper'

#########################################

#Defines a model class which implements the status bar gem.
class MyClass < ActiveRecord::Base
  
  # Helper which makes all the status_bar functions available.
  acts_as_status_bar
  
  MAX = 100
  
  def save
  end
  
  #Initializes an object and its relative status bar passing its id as an options hash
  def initialize(*args)
    options = args.extract_options!
    status_bar_id = options.delete(:status_bar_id) if options[:status_bar_id]
    puts"\n\nstatus_bar_id = #{status_bar_id}"
    self.status_bar = ActsAsStatusBar::StatusBar.new(:id => @status_bar_id)
    # super
  end
  
  def destroy
    # status_bar_init(self)
    bar = status_bar_init(self) do
      self.delete
    end  
  end
  
  # def clear_bar
    # status_bar.delete
  # end
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
    #I'm incrementing the status bar 'current' attribute by the value of 10.
    status_bar.inc(10)
    #I'm assuring status_bar and object_status_bar both refer to the really same bar
    #checking that 'current' attribute was incremented.
    status_bar.current.should equal(object.status_bar.current)
  end
  
  it "should be deleted once the parent object is saved" do
    object.save
    object.status_bar.should be nil
  end
  
  it "should be deleted once the parent object is destroyed" do
    object.destroy
    object.status_bar.should be nil
  end

  # it "should assign the right id to #status_bar_id method" do
    # object.status_bar_id.should equal(object.status_bar.id)
  # end
  
  # it "should be destroyed by destroying the parent object" do
    # object.destroy!.should be_true, object.errors
    # object.status_bar.should be nil
  # end
end
