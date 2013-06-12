class MarketingPagesController < ApplicationController
	before_filter :load_cart
	before_filter :clear_state

	def home
		@page_title = "Home page"
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

	def feedback 
		if !params[:honey].blank? 
			# BOT ALERT!
			#flash[:error] = "Die BOT!"
			redirect_to root_path
		else
			if(!params[:name].blank? && !params[:email].blank? && !params[:message].blank?)
				#-- FEEDBACK EMAIL ONLY ENABLED FOR PRODUCTION
				if Rails.env.production?
					UserMailer.feedback_email(params[:name], params[:email], params[:message]).deliver
				end 
				flash[:success] = "Thanks for sending us a feedback.  We'll get back to you!"
				redirect_to root_path
			else
				@feedback_name = params[:name]
				@feedback_email = params[:email]
				@feedback_message = params[:message]
				@mode = "feedback"
				
				flash[:error] = "Please fill in all the fields"
				@locations = Location.all
				render "home", layout: "marketing"
			end
		end
	end
	
	def faq
		@page_title = "FAQ"
		@info = "faq"
		@title = "Frequently Asked Questions" 
		render "info"
	end
	def about
		@page_title = "About Us"
		@info = "about"
		@title = "About Us" 
		render "info"
	end
	def contact
		@page_title = "Contact Us"
		@info = "contact"
		@title = "Contact Us" 
		render "info"
	end
	def copyright
		@page_title = "Copyright"
		@info = "copyright"
		@title = "Copyright" 
		render "info"
	end
	
	private
	def load_cart
		if not session.has_key? :cart
			session[:cart] = Array.new
		end
		@cart = session[:cart]
	end

end
