class PurchaseItem < ActiveRecord::Base
  attr_accessible :description, :product_id, :purchase_id, :quantity, :total_price, :unit_price
end
