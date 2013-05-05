module ApplicationHelper
	require 'nokogiri'
	
	def honeypot
		if params.has_key?(:honey)
			if params[:honey].length > 0
				redirect_to 'http://www.sadtrombone.com/?play=true'	
				return true 
			end 
		end
	end

	def has_purchase_format(cart, *formats)
		cart.each_with_index do |cart_item, index|
			product = Product.find(cart_item[:product_id])
			if !product.nil?
				if !formats.index(product.format).nil?
					return true 
				end
			end
		end
		false
	end
	
	def calc_price(quantity, product)
		additional = quantity - 1
		price = product.price
		price = price + (additional * 1.5)
	end

	def clear_state
		@return_to = session[:return_to]
		@need_addy = session[:need_addy]
		session.delete(:return_to)
		session.delete(:need_addy)
	end

	def	set_state
		session[:return_to] = @return_to
		session[:need_addy] = @need_addy
	end

	def need_address(val)
		# expects "yes" or "no"
		@need_addy = val
	end

	def need_address?
		@need_addy == "yes"
	end
	
	def set_return_to(val)
		@return_to = val
	end

	def return_to
		@return_to
	end
	
#	def store_location
#		session[:return_to] = request.fullpath
#	end	

	def redirect_back_or(default)
		redirect_to(@return_to || default)
#		session.delete(:return_to)
	end
	
#	def free_location
#		session.delete(:return_to)
#	end

	def in_checkout?
		@return_to == "/checkout"
#		session[:return_to] == "/checkout"
	end

	def load_xml(model, xml)	
		if model.blank?
			f = File.open( XML_PATH + xml)
		else
			f = File.open( XML_PATH + "#{model}s/" + xml)
		end
		doc = Nokogiri::XML(f)
		f.close
		doc
	end

	def get_xml_node(model, xml, xpath)
		doc = load_xml(model, xml)
		node = doc.xpath(xpath)
		node
	end
	
	def transform_xml(model, xml)
		
		doc = load_xml(model, xml)
		xslt  = Nokogiri::XSLT(File.read(XSL_PATH + "#{model}.xslt"))
		
		xslt.transform(doc)
	
	end
end
