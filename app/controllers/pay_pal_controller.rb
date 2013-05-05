class PayPalController < ApplicationController
	include ActiveMerchant::Billing::Integrations
	protect_from_forgery :except => [:create, :paypal_return] 
	before_filter :load_cart
	
	def create
	end
  
	def notify
		#for testing:
		#http://localhost:3000/paypal_notify?mc_gross=19.95&protection_eligibility=Eligible&address_status=confirmed&payer_id=LPLWNMTBWMFAY&tax=0.00&address_street=1+Main+St&payment_date=20%3A12%3A59+Jan+13%2C+2009+PST&payment_status=Completed&charset=windows-1252&address_zip=95131&first_name=Test&mc_fee=0.88&address_country_code=US&address_name=Test+User&notify_version=2.6&custom=&payer_status=verified&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AtkOfCXbDm2hu0ZELryHFjY-Vb7PAUvS6nMXgysbElEn9v-1XcmSoGtf&payer_email=gpmac_1231902590_per%40paypal.com&txn_id=61E67681CH3238416&payment_type=instant&last_name=User&address_state=CA&receiver_email=gpmac_1231902686_biz%40paypal.com&payment_fee=0.88&receiver_id=S8XGHLYDW9T3S&txn_type=express_checkout&item_name=&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&handling_amount=0.00&transaction_subject=&payment_gross=19.95&shipping=0.0
		
		#handle PAYPAL notification
		notify = Paypal::Notification.new request.raw_post

		# TODO: find the purchase in the DB?		

		#if notify.acknowledge
			notification = IpnLog.new
			notification.purchase_id = notify.item_id
			notification.item_id = notify.item_id
			notification.transaction_id = notify.transaction_id
			notification.currency = notify.currency
			notification.fee = notify.fee
			notification.gross = notify.gross
			notification.invoice = notify.invoice
		#	notification.received_at = notify.received_at
			notification.status = notify.status
			notification.type = notify.type
			
			if notify.complete? then notification.complete = true end
			if notify.test? then notification.test = true end
			
			if notification.save 
			
			end 

			if notify.test?
			
			end 
			
			if notify.complete? #and @order.price == BigDecimal.new( params[:mc_gross] )
				# todo update purchase
			end 
			
		#	render :nothing => true
		
		#else
			#LOG hacking attempt?
			
		#end
		
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