class Purchase < ActiveRecord::Base
	attr_accessible :date_purchased, :price_total, :reference, :user_id
  	has_many :purchase_items, dependent: :destroy
  	has_many :ipn_logs, dependent: :destroy
  	belongs_to :user
end
# == Schema Information
#
# Table name: purchases
#
#  id             :integer         not null, primary key
#  date_purchased :datetime
#  reference      :string(255)
#  price_total    :integer
#  user_id        :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

