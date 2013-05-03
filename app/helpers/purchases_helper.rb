module PurchasesHelper

	def create_payment(purchase, params = {})
	
		online_only = true
		purchase_total = 0 
		num = 1
		until !params.key?("amount_#{num}") do
			item = purchase.purchase_items.new
			item.description = params["item_name_#{num}"]
			item.quantity = params["quantity_#{num}"]
			item.total_price = params["amount_#{num}"]

			# Get the product 
			product_id = params["item_number_#{num}"]
			item.product = Product.find(product_id)
			item.unit_price = item.product.price
			
			# If it's online, create the hunt
			if item.product.format == "Online"
				for i in 1..item.quantity
					hunt = item.hunts.new
					hunt.product = item.product
					hunt.user = current_user
				end
			else 
				online_only = false
			end
			
			purchase_total = purchase_total + item.total_price
			num +=1
		end
		
		purchase.date_purchased = DateTime.now
		purchase.reference = params[:reference]
		purchase.price_total = purchase_total
		purchase.user = current_user
		
		# If only online hunt, set dispatch date
		if online_only 
			purchase.dispatch_date = DateTime.now
		end
	
	end
end
