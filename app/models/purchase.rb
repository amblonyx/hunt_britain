class Purchase < ActiveRecord::Base
  attr_accessible :date_purchased, :price_total, :reference, :user_id
end
