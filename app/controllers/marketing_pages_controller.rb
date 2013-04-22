class MarketingPagesController < ApplicationController
	before_filter :load_cart
	before_filter :clear_state

	def home
		if params.has_key?(:voucher)
			redirect_to '/hunt_login?voucher=' + params[:voucher]
		else
			@locations = Location.all
			render layout: "marketing"				
		end 
	end
	
	def accordion
		@location = Location.find(params[:id])
		respond_to do |format|
			format.html
			format.js  { render "accordion.js" }
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
