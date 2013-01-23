class CreateRoomTypes < ActiveRecord::Migration
  def change
    create_table :room_types do |t|
      t.string :name
      t.string :class_name
      t.string :options
      t.string :description

      t.timestamps
    end
  end
end
