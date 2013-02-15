class ChangeCurrentClueOfHunts < ActiveRecord::Migration
  def up
	change_column :hunts, :current_clue, :integer
  end

  def down
  end
end
