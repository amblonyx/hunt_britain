class AddHuntGroupToHunts < ActiveRecord::Migration
  def change
	add_column :hunts, :hunt_group, :string
  end
end
