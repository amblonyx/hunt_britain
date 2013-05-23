class ChangeDormantOfProducts < ActiveRecord::Migration
  def up
	change_column :products, :dormant, :boolean, default: false
  end

  def down
  end
end
