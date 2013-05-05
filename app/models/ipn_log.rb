class IpnLog < ActiveRecord::Base
	belongs_to :purchase
	attr_accessible :complete, :currency, :fee, :gross, :invoice, :item_id, :purchase_id, :received_at, :status, :test, :transaction_id, :type
end
