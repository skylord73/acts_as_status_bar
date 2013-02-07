class CreateActsAsStatusBar < ActiveRecord::Migration
  def self.up
    create_table "acts_as_status_bar" do |t|
      t.integer :current
      t.integer :max
    end
  end
  
  def self.down
    drop_table :acts_as_status_bar
  end
  
end
