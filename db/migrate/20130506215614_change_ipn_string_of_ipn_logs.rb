class ChangeIpnStringOfIpnLogs < ActiveRecord::Migration
  def up
	change_column :ipn_logs, :ipn_string, :text
  end

  def down
	change_column :ipn_logs, :ipn_string, :string
  end
end
