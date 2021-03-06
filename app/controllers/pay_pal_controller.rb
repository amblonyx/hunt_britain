class PayPalController < ApplicationController
	include ActiveMerchant::Billing::Integrations
	protect_from_forgery :except => [:create, :paypal_return] 
	before_filter :load_cart

	# For testing email and delivery system
	def notify_test

		# FORMAT of URL: paypal_notify_test?ref=bde974613f&updatestatus=N&emailconfirm=N&createhunt=N&emaildeliver=N&testonly=N&redirect=N
		if params.has_key?(:ref)
			@reference = params[:ref]
			@purchase = Purchase.find_by_internal_ref(@reference)	
			
			
			if !@purchase.nil?
				if params[:testonly] != "N" && !@purchase.test?
					@comment = "Not a test purchase!  Use parameter 'testonly=N' to continue anyway"
					render layout: pick_layout	
				else 
					if params[:updatestatus] != "N"
						@purchase.status = "Paid"
						@purchase.save
					end
					
					if params[:emailconfirm] != "N"
						# Send a confirmation email for purchase
						UserMailer.confirm_purchase(@purchase).deliver
					end 
					
					if params[:createhunt] != "N"
						# Create online hunts  
						has_paper = false 
						@purchase.purchase_items.each do |item|
							num = 1
							
							if item.product.format == "Online"
								for num in 1..item.quantity
									hunt = Hunt.new
									hunt.product = item.product
									hunt.user = @purchase.user
									hunt.purchase_item = item 
									if (item.quantity > 1) 
										if num == 1
											hunt_group = hunt.generate_hunt_group
										else
											hunt.hunt_group = hunt_group
										end
									end
									hunt.save
								end 
							elsif item.product.format == "Paper"
								has_paper = true 
							end
						end
					end 
					
					if params[:emaildeliver] != "N"
						# Deliver online and PDF hunts
						UserMailer.deliver_purchases(@purchase).deliver
					end 
					
					if params[:updatestatus] != "N"
						# If we don't need to send out paper booklets, set dispatch date
						if !has_paper
							@purchase.dispatch_date = DateTime.now
							@purchase.save
						end 
					end
					
					if params[:redirect] != "N"
						redirect_to action: "show", item_number: @purchase.id	
					else
						@comment = "Reference #{@reference} - TEST SUCCESSFUL"
						render layout: pick_layout						
					end
				end
			else
				@comment = "Reference #{@reference} not found"
				render layout: pick_layout	
			end  
			
		else
			redirect_to root_path
		end													
	end
	
	def notify
		#Resource on IPN: https://cms.paypal.com/uk/cgi-bin/?cmd=_render-content&content_ID=developer/e_howto_admin_IPNIntro
			
		#handle PAYPAL notification
		notify = Paypal::Notification.new request.raw_post

		notification = IpnLog.new
		notification.purchase_id = notify.item_id
		notification.item_id = notify.item_id
		notification.transaction_id = notify.transaction_id
		notification.currency = notify.currency
		notification.fee = notify.fee
		notification.gross = notify.gross
		notification.invoice = notify.invoice
		notification.received_at = DateTime.now #notify.received_at
		notification.status = notify.status
		notification.type = notify.type
		notification.ipn_string = request.raw_post
		
		notification.complete = notify.complete?
		notification.test = notify.test?
		
		# TODO: ADD CHECK ON IPN TRACKING ID (ipn_track_id) TO AVOID PROCESSING DUPLICATE NOTIFICATIONS
		
		if notify.acknowledge									# comment out to test locally
			# Find the purchase 	
			@purchase = Purchase.find_by_id(notify.item_id)		# replace with @purchase = Purchase.last to test locally
#			@purchase = Purchase.last
			
			# Perform additional checks to make sure that notify is legitimate and not already processed
			#if notify.complete? &&  							# comment out to test locally
			#		@purchase.price_total.to_s == notify.gross.to_s && 
			#		@purchase.id.to_s == notify.item_id.to_s && 
			#		@purchase.reference == notify.invoice && 
			#		@purchase.status != "Paid"			
			if notify.complete?
				@purchase.status = "Paid"
				@purchase.save

				# Send a confirmation email for purchase
				UserMailer.confirm_purchase(@purchase).deliver

				# Create online hunts  
				has_paper = false 
				@purchase.purchase_items.each do |item|
					num = 1
					if item.product.format == "Online"
						for num in 1..item.quantity
							hunt = Hunt.new
							hunt.product = item.product
							hunt.user = @purchase.user
							hunt.purchase_item = item 
							if (item.quantity > 1) 
								if num == 1
									hunt_group = hunt.generate_hunt_group
								else
									hunt.hunt_group = hunt_group
								end
							end
							hunt.save
						end 
					elsif item.product.format == "Paper"
						has_paper = true 
					end
				end

				# Deliver online and PDF hunts
				UserMailer.deliver_purchases(@purchase).deliver
				
				# If we don't need to send out paper booklets, set dispatch date
				if !has_paper
					@purchase.dispatch_date = DateTime.now
					@purchase.save
				end 
			else 											# comment out to test locally
				notification.status = "ANOMALY" 			# comment out to test locally
			end  											# comment out to test locally
		else 												# comment out to test locally
			notification.status = "HACKING ATTEMPT"			# comment out to test locally
		end													# comment out to test locally

		notification.save 
		render nothing: true
		
	end
  
	def show
		# HANDLE SUCCESSFUL PAYMENT TRANSACTION
		session[:cart] = Array.new
		@purchase = Purchase.find_by_id(params[:item_number].to_i)
		if @purchase.nil?
			redirect_to root_path
		else
			render layout: pick_layout
		end 
	end
  
	private
 	def load_cart
		if not session.has_key? :cart
			session[:cart] = Array.new
		end
		@cart = session[:cart]
	end

  
end