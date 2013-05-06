class PayPalController < ApplicationController
	include ActiveMerchant::Billing::Integrations
	protect_from_forgery :except => [:create, :paypal_return] 
	before_filter :load_cart
	
	def create
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
		notification.ipn_string = request.query_string
		
		notification.complete = notify.complete?
		notification.test = notify.test?
		
		if notify.acknowledge
			# Find the purchase 	
			@purchase = Purchase.find_by_id(notify.item_id)
			
			# Perform additional checks to make sure that notify is legitimate and not already processed
			if notify.complete? and @purchase.price_total == notify.gross and @purchase.id == notify.item_id and @purchase.reference == notify.invoice and @purchase.status != "Paid"
				@purchase.status = "Paid"
				@purchase.save

				# Send a confirmation email for purchase
				UserMailer.confirm_purchase(@purchase).deliver
				# Deliver online and PDF hunts
				UserMailer.deliver_purchases(@purchase).deliver
			else
				notification.status = "ANOMALY"
			end 
		else 
			notification.status = "HACKING ATTEMPT"
		end

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