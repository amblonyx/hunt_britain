class Product < ActiveRecord::Base
	attr_accessible :data_file, :format, :name, :price, :product_code, :dormant
	belongs_to :location
	has_many :hunts
	#  has_many :purchase_items

	scope :dormant, where(dormant: true)
	scope :active, where(dormant: false)

	def self.filtered( opts = {}, sort = {} )
		fields = Array.new
		criteria = Hash.new

		if opts.has_key?(:location)
			if !opts[:location].empty?
				fields.push("locations.name ilike :location")
				criteria[:location] = "%#{opts[:location]}%"
			end 
		end
		if opts.has_key?(:format)
			if !opts[:format].empty?
				fields.push("format = :format")
				criteria[:format] = opts[:format]
			end
		end
		if opts.has_key?(:name)
			if !opts[:name].empty?
				fields.push("products.name ilike :name")
				criteria[:name] = "%#{opts[:name]}%"
			end
		end
		if opts.has_key?(:product_code)
			if !opts[:product_code].empty?
				fields.push("product_code ilike :product_code")
				criteria[:product_code] = "%#{opts[:product_code]}%"
			end
		end
		if opts[:dormant].to_i != 1
			fields.push("dormant = false")
		end
		
		field_string = fields.join(" AND ")
		result = self.joins(:location).where( field_string, criteria ).order( "#{sort[:field]} #{sort[:dir]}" )

		return result
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

