class AddLastUpdateToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :last_update, :integer, :null => false, :default => 0, :limit => 8
  end
end
