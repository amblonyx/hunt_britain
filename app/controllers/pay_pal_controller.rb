class PayPalController < ApplicationController
	include ActiveMerchant::Billing::Integrations
	protect_from_forgery :except => [:create, :paypal_return] 
	before_filter :load_cart
	
	def create
	end
  
	def notify
		#handle PAYPAL notification
		notify = Paypal::Notification.new request.raw_post

		# TODO: find the purchase in the DB?		

		if notify.acknowledge
			notification = Notification.new
			notification.purchase_id = notify.item_id
			notification.item_id = notify.item_id
			notification.transaction_id = notify.transaction_id
			notification.complete = notify.complete
			notification.currency = notify.currency
			notification.fee = notify.fee
			notification.gross = notify.gross
			notification.invoice = notify.invoice
			notification.received_at = notify.received_at
			notification.status = notify.status
			notification.test = notify.test
			notification.type = notify.type
			
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