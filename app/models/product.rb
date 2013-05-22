class Product < ActiveRecord::Base
  attr_accessible :data_file, :format, :name, :price, :product_code, :dormant
  belongs_to :location
  has_many :hunts
#  has_many :purchase_items

	def self.filtered( opts = {} )
		fields = Array.new
		criteria = Hash.new
		
		if !opts[:format].empty?
			fields.push("format = :format")
			criteria[:format] = opts[:format]
		end
		if !opts[:name].empty?
			fields.push("name ilike :name")
			criteria[:name] = "%#{opts[:name]}%"
		end
		if !opts[:product_code].empty?
			fields.push("product_code ilike :product_code")
			criteria[:product_code] = "%#{opts[:product_code]}%"
		end
		if !opts[:dormant].empty?
			fields.push("dormant = :dormant")
			criteria[:dormant] = opts[:dormant]
		end

		field_string = fields.join(" AND ")
		x = self.where( field_string, criteria ) 
		return x
		
	end

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

