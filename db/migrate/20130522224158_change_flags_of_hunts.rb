class ChangeFlagsOfHunts < ActiveRecord::Migration
  def up
	change_column :hunts, :started, :boolean, default: false
	change_column :hunts, :paused, :boolean, default: false
	change_column :hunts, :completed, :boolean, default: false
  end

  def down
  end
end
