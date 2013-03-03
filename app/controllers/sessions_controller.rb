class SessionsController < ApplicationController
	before_filter :load_cart
	
	def new
		@user = User.new
	end
	
	def create
		if params[:identify] == "signin"
			user = User.find_by_user_name(params[:session][:email])
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
		elsif params[:identify] == "guest"
			@user = User.new
			@user.email = params[:session][:email]
			@user.password = "password"
			@user.guest = true 
			
			if @user.save 
				sign_in @user
				redirect_back_or @user				
			else
				flash.now[:error] = "Problem with email"
				render 'new'
			end

		else
			redirect_to signup_path
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
	end
	
	def add_to_cart
		consolidate_cart
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
		redirect_to "/cart"
	end
	
	def remove_from_cart
		# match on product id
		@cart.reject! { |item| item[:product_id] == params[:product_id]  }
		redirect_to "/cart"
	end
	
	def update_cart
		
		consolidate_cart
		params[:product].each do |key, value|
			cart_items = @cart.select { |item| item[:product_id] == key }
			if cart_items.length > 0
				cart_items.first[:num] = value
			end 
		end

		
		@action = "cart"
		render "cart"
		# redirect_to "/cart"
	end

	def checkout
		not_signed_in_user
		
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
		render "cart"
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
	
	def consolidate_cart
#		newcart = Array.new
		@cart.each do |cart_item|
			if cart_item[:num].to_i == 0
				@cart.delete_at(0)
			else
#				newcart.push(cart_item)
				@cart.delete_at(0)
				dups = @cart.select { |dup| dup[:product_id] == cart_item[:product_id] }
				dups.each do |dup| 
					cart_item[:num] = cart_item[:num].to_i + dup[:num].to_i
					#newcart.last[:num] = newcart.last[:num].to_i + dup[:num].to_i
				end
				@cart.reject! { |dup| dup[:product_id] == cart_item[:product_id]  }
			end
			@cart.prepend(cart_item)
		end
		return @cart #= newcart
	end
end
