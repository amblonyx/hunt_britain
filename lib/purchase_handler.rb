module PurchaseHandler
	
	def generate_paypal_link

		if @purchase.purchase_items.count > 1
			iname = "Your Treasure Hunts"
			iqty = 1
		else
			iname = @purchase.purchase_items.first.description
			iqty = @purchase.purchase_items.first.quantity
		end
		
		paypal_params = {
			business: PAYPAL_ACCOUNT,
			currency_code: "GBP",
			cmd: "_ext-enter",
			redirect_cmd: "_xclick",
			
			invoice: @purchase.reference,
			item_number: @purchase.id,
			custom: @purchase.id,
			amount: @purchase.price_total,
			quantity: iqty,
			item_name: iname,
			no_shipping: "1",
			no_note: "1",
			charset: "utf-8",
			address_override: "0",
			#first_name, last_name, email, invoice, tax
			#cmd: '_cart', upload: 1,
			
			notify_url: "#{request.protocol}#{request.host_with_port}/paypal_notify",
			return: "#{request.protocol}#{request.host_with_port}/paypal_show",
			cancel_return: "#{request.protocol}#{request.host_with_port}/cart"
		}
		PAYPAL_LINK + paypal_params.to_query
				
	end 
	
	def create_purchase(purchase, cart)
	
		purchase_total = 0 
		num = 1

		cart.each_with_index do |cart_item, index|
			real_index = index + 1
			
			# Find the product
			product = Product.find(cart_item[:product_id])

			# Create the new purchase item
			item = purchase.purchase_items.new
			item.product = product
			item.description = product.name
			item.quantity = cart_item[:num]
			item.unit_price = item.product.price
			item.total_price =  "%.2f" % (calc_price(cart_item[:num].to_i, product))
		
			purchase_total = purchase_total + item.total_price
			num +=1
		end
		
		purchase.date_purchased = DateTime.now
		purchase.reference = SecureRandom.hex(5) 
		purchase.internal_ref = loop do
		  random_ref = SecureRandom.hex(5) 
		  break random_ref unless Purchase.where(internal_ref: random_ref).exists?
		end
		purchase.internal_ref = SecureRandom.hex(5) 
		purchase.price_total = purchase_total
		purchase.user = current_user
		purchase.status = "Raised"
	end
	
end
