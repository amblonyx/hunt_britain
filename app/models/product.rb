class Product < ActiveRecord::Base
  attr_accessible :data_file, :format, :name, :price, :product_code
  belongs_to :location
  has_many :hunts

end
# == Schema Information
#
# Table name: products
#
#  id           :integer         not null, primary key
#  product_code :string(255)
#  name         :string(255)
#  format       :string(255)
#  price        :integer
#  data_file    :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  location_id  :integer
#

