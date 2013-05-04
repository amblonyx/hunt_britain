class PayPalController < ApplicationController
	include ActiveMerchant::Billing::Integrations
	protect_from_forgery :except => [:create, :paypal_return] 
	before_filter :load_cart
	
	def create

	#    _user = {:first_name => "saran", :last_name => "v", :email => "svigra_1317161804_per@gmail.com", :address1 => "awesome ln", :city => "Austin", :state => "TX", :zip => "78759", :country => "USA", :phone => "5120070070" }
	#    @user = OpenStruct.new _user
	#    @amount = "0.01"
	#    @currency = "USD"
	#a random invoice number for test
	#    @invoice = Integer rand(1000)
	#    @item_number = "123"
	
	end
  
	def notify
		#handle notification here - LOG IT?
		notify = Paypal::Notification.new request.raw_post
		# TODO: find the purchase in the DB?		
		p notify
		if notify.acknowledge
		  p "Transaction ID is #{notify.transaction_id}"
		  p "Notify is #{notify}"
		  p "Notify status is #{notify.status}"
		end
		render :nothing => true
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