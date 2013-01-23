class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.integer :device_type_id
      t.string :options
      t.string :description

      t.timestamps
    end
  end
end
