class AddDetailsToUsers < ActiveRecord::Migration
  def change
	add_column :users, :address_1, :string
	add_column :users, :address_2, :string
	add_column :users, :town, :string
	add_column :users, :county, :string
	add_column :users, :postcode, :string
	add_column :users, :country, :string
	add_column :users, :phone, :string
  end
end
