require 'spec_helper'

#########################################

#Define a class which implements the status bar gem.
class MyClass
  acts_as_status_bar
  
  MAX = 100
  
  def initialize 
    status_bar_init
  end
  
  def clear_destroy
    status_bar_init
    status_bar.message = "Cancellazione in corso..."
    status_bar.max = MAX
    billing_bodies.each {|bb| bb.status_bar_id = self.status_bar_id}
    mylog("clear_destroy: bar:#{status_bar.inspect}")
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
    ActsAsStatusBar.should be_a(Class)
  end
  
  it "viene cancellata insieme all'oggetto padre" do
    object.destroy!.should be_true, object.errors
    object.status_bar.should be nil
  end
end
