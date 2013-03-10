class SessionsController < ApplicationController
	before_filter :load_cart
	
	def new
		@user = User.new
	end
	
	def create
		@user = User.new
		if params[:guest_user]
			if @user.is_valid_email?(params[:session][:email])
				#remember_guest params[:session][:email]
				#redirect_back_or "/cart"
				redirect_to "/cart"		
				
			else
				flash[:error] = "Invalid email"
				hash = {from: "checkout"}
				not_signed_in_user (hash)
			end			

		else
			user = User.find_by_user_name(params[:session][:user_name])
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
	end
	
	def destroy
		sign_out
		redirect_back_or root_path
	end

	def cart
		@action = "cart"
		paypal_params = {
			business: 'huntbr_1361011425_biz@gmail.com',
			cmd: '_cart',
			upload: 1,
			return: '/payment_success',
		}
	end
	
	def add_to_cart
		pid = params[:product_id]
		if params[:num] and params[:product_id]
			matching = Product.where(id: pid)
			if matching.length > 0
				
				cart_items = @cart.select { |item| item[:product_id] == pid }
				if cart_items.length == 0 
					@cart.push({ product_id: pid, num: params[:num].to_i})
				else
					cart_items.first[:num] = cart_items.first[:num].to_i + params[:num].to_i
				end 
			end
		end
		#consolidate_cart
		redirect_to "/cart"
	end
	
	def remove_from_cart
		# match on product id
		@cart.reject! { |item| item[:product_id] == params[:product_id]  }
		redirect_to "/cart"
	end
	
	def update_cart
		
		params[:product].each do |key, value|
			cart_items = @cart.select { |item| item[:product_id] == key }
			if cart_items.length > 0
				cart_items.first[:num] = value
			end 
		end
		consolidate_cart

		@action = "cart"
		render "cart"
		# redirect_to "/cart"
	end

	def checkout
		if @cart.length == 0 
			redirect_to "/cart"
		else
			if identified?
				if signed_in?
					@user = current_user
				else
					@user = guest_user
				end
				
				@action = "checkout"
				paypal_params = {
					business: 'huntbritain@gmail.com',
					cmd: '_cart',
					upload: 1,
					notify_url: '',
					return: '/success',
					currency_code: 'GBP',
					invoice: ''
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
				render "cart"
			else
				hash = {from: "checkout"}
				not_signed_in_user (hash)
			end
		end
	end
	
	def success
	  session[:cart] = Array.new
	end
	
	private
	
	def load_cart
		if not session.has_key? :cart
			session[:cart] = Array.new
		end
		@cart = session[:cart]
	end
	
	def consolidate_cart
		@cart.each do |cart_item|
			if cart_item[:num].to_i == 0
				@cart.delete_at(0)
			else
				@cart.delete_at(0)
				dups = @cart.select { |dup| dup[:product_id] == cart_item[:product_id] }
				dups.each do |dup| 
					cart_item[:num] = cart_item[:num].to_i + dup[:num].to_i
				end
				@cart.reject! { |dup| dup[:product_id] == cart_item[:product_id]  }
				@cart.prepend(cart_item)
			end
		end
		return @cart 
	end
end
