class AddTestToPurchases < ActiveRecord::Migration
  def change
     add_column :purchases, :internal_ref, :string
	 add_index :purchases, :internal_ref, unique: true
     add_column :purchases, :test, :boolean, default: false
  end
end
