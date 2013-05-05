class CreateIpnLogs < ActiveRecord::Migration
  def change
    create_table :ipn_logs do |t|
      t.integer :purchase_id
      t.integer :transaction_id
      t.boolean :complete
      t.string :currency
      t.string :fee
      t.decimal :gross
      t.string :invoice
      t.integer :item_id
      t.datetime :received_at
      t.string :status
      t.boolean :test
      t.string :type

      t.timestamps
    end
  end
  def down
	drop_table :ipn_logs
  end
end
