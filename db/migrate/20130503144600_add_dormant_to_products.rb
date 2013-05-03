class AddDormantToProducts < ActiveRecord::Migration
  def up
	add_column :products, :dormant, :boolean
  end
  def down
	remove_column :products, :dormant
  end
end
