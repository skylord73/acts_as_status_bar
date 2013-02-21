require 'spec_helper'

#########################################

class MyClass
  acts_as_status_bar
  
  def initialize 
    status_bar_init
  end
  
  def destroy
    self.status_bar.delete
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
  
  it "deletes by deleting the parent object" do
    object.destroy!.should be_true, object.errors
    object.status_bar.should be nil
  end
end
