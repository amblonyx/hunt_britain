class PurchaseItem < ActiveRecord::Base
  attr_accessible :description, :product_id, :purchase_id, :quantity, :total_price, :unit_price
  belongs_to :purchase
  belongs_to :product
  has_many :hunts
end
# == Schema Information
#
# Table name: purchase_items
#
#  id          :integer         not null, primary key
#  product_id  :integer
#  purchase_id :integer
#  quantity    :integer
#  unit_price  :integer
#  total_price :integer
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

