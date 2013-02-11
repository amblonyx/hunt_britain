class Product < ActiveRecord::Base
  attr_accessible :data_file, :format, :name, :price, :product_code
  belongs_to :location
end
