class AddStatusToPurchases < ActiveRecord::Migration
  def up
	add_column :purchases, :status, :string
	add_column :ipn_logs, :ipn_string, :string
  end
  def down
	remove_column :purchases, :status
	remove_column :ipn_logs, :ipn_string
  end
end
