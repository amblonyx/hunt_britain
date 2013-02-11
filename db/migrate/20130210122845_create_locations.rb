class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :description
      t.string :hunt_mode
      t.string :image
      t.string :region

      t.timestamps
    end
  end
end
