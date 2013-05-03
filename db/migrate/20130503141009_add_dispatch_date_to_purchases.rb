class AddDispatchDateToPurchases < ActiveRecord::Migration
  def up
	add_column :purchases, :dispatch_date, :datetime
	change_column :purchases, :price_total, :decimal, precision: 8, scale: 2

	change_column :purchase_items, :unit_price, :decimal, precision: 8, scale: 2
	change_column :purchase_items, :total_price, :decimal, precision: 8, scale: 2

	change_column :products, :price, :decimal, precision: 8, scale: 2

	add_column :hunts, :purchase_item_id, :integer
  end
  def down
	remove_column :purchases, :dispatch_date
	change_column :purchases, :price_total, :integer

	change_column :purchase_items, :unit_price, :integer
	change_column :purchase_items, :total_price, :integer

	change_column :products, :price, :integer

	remove_column :hunts, :purchase_item_id
  
  end
end
