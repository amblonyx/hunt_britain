class ChangePriceOfProducts < ActiveRecord::Migration
  def up
	change_column :products, :price, :integer
  end

  def down
  end
end
