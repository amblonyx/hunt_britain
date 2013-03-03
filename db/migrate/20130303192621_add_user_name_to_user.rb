class AddUserNameToUser < ActiveRecord::Migration
  def up
	add_column :users, :user_name, :string
	add_index :users, :user_name, unique: true
	
	add_column :users, :guest, :boolean, default: false

	add_index :users, :email
  end
  
  def down
	remove_column :users, :user_name
	remove_column :users, :guest
	remove_index :users, :email
  end
end
