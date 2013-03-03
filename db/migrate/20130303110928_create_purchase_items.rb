class CreatePurchaseItems < ActiveRecord::Migration
  def change
    create_table :purchase_items do |t|
      t.integer :product_id
      t.integer :purchase_id
      t.integer :quantity
      t.integer :unit_price
      t.integer :total_price
      t.string :description

      t.timestamps
    end
  end
end
