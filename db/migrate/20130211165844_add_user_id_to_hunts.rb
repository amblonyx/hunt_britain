class AddUserIdToHunts < ActiveRecord::Migration
  def change
     add_column :hunts, :user_id, :integer
  end
end
