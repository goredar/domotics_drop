class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.string :name
      t.integer :room_id
      t.integer :device_id
      t.integer :element_type_id
      t.string :options
      t.string :description

      t.timestamps
    end
  end
end
