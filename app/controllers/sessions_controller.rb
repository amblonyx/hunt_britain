class SessionsController < ApplicationController
	before_filter :load_cart
	
	def new
	end
	
	def create
		user = User.find_by_email(params[:session][:email])
		if user && user.authenticate(params[:session][:password]) 
			# SessionsHelper functions...
			#	sign_in 1) sets the cookies remember_token  2) sets current_user
			sign_in user
			#	redirect_back_or 1) redirects to previously stored location OR default (user)
			redirect_back_or user
		else
			flash.now[:error] = "Invalid email/password combination"
			render 'new'
		end
	end
	
	def destroy
		sign_out
		redirect_to root_path
	end

	def cart
		@action = "cart"
		paypal_params = {
			business: 'huntbr_1361011425_biz@gmail.com',
			cmd: '_cart',
			upload: 1,
			return: '/payment_success',
		}
		render layout: "user"		
	end
	
	def add_to_cart
		if params[:num] and params[:product_id]
			matching = Product.where(:id => params[:product_id])
			if matching.length > 0
				@cart.push({ :product_id => params[:product_id], :num => params[:num].to_i})
			end
		end
		redirect_to "/cart"
	end
	
	def remove_from_cart
	
	end
	
	def update_cart
	
	end

	def checkout
		@action = "checkout"
		paypal_params = {
			business: 'huntbr_1361011425_biz@gmail.com',
			cmd: '_cart',
			upload: 1,
			return: '/success',
		}
		@cart.each_with_index do |cart_item, index|
			real_index = index + 1
			product = Product.find(cart_item[:product_id])
			paypal_params.merge!({
				"amount_#{real_index}" => "%.2f" % (product.price / 100.0),
				"item_name_#{real_index}" => product.name,
				"item_number_#{real_index}" => product.id,
				"quantity_#{real_index}" => cart_item[:num],
		})
		end
		@paypal_link = "https://www.sandbox.paypal.com/cgi-bin/webscr?" + paypal_params.to_query
		render "cart", layout: "user"
	end
	
	def payment_success
	  session[:cart] = Array.new
	end
	
	private
	def load_cart
		if not session.has_key? :cart
			session[:cart] = Array.new
		end
		@cart = session[:cart]
	end
end
