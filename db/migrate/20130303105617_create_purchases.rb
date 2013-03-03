class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.datetime :date_purchased
      t.string :reference
      t.integer :price_total
      t.integer :user_id

      t.timestamps
    end
  end
end
