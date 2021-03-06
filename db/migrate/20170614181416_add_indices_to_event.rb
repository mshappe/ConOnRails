class AddIndicesToEvent < ActiveRecord::Migration
  def change
    add_index :events, :is_active
    add_index :events, :sticky
    add_index :events, :emergency
    add_index :events, :medical
    add_index :events, :secure
    add_index :events, :hotel
  end
end
