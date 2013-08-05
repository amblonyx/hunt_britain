class AddHunterTokenToHunts < ActiveRecord::Migration
  def change
	add_column :hunts, :hunter_token, :string
  end
end
