class PayPalController < ApplicationController
	include ActiveMerchant::Billing::Integrations
	protect_from_forgery :except => [:create, :paypal_return] 
	before_filter :load_cart
	
	def create
	end
  
	def notify
		#handle notification here - LOG IT?
		notify = Paypal::Notification.new request.raw_post

		# TODO: find the purchase in the DB?		

		if notify.acknowledge
			#convert notify to HASH
			notify.instance_variables.each do |var| 
				hash[var.to_s] = notify.instance_variable_get(var) 
			end 
			notification = Notification.new(hash)
			notification.purchase_id = notify.item_id
			if notification.save 
			
			end 
			
			if notify.complete? #and @order.price == BigDecimal.new( params[:mc_gross] )
				# todo update purchase
			end 
			
			render :nothing => true
			
		#rescue
			#LOG Exceptions
		end
		
	end
  
	def show

	end
	def cancel
	
	end
  
	private
 	def load_cart
		if not session.has_key? :cart
			session[:cart] = Array.new
		end
		@cart = session[:cart]
	end

  
end