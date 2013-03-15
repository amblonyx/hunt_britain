class SessionsController < ApplicationController
	before_filter :load_cart
	
	def new			
		@user = User.new
		if params[:from] == "checkout"
			render layout: "processing"
		else
			render
		end 
	end
	
	def create
		@user = User.new
		if params[:guest_user]
			if @user.is_valid_email?(params[:session][:email])
				if cart_needs_address
					if !params[:session][:address_1].blank?
						if !params[:session][:postcode].blank? 
							all_valid = true
						else
							flash[:error] = "Please enter a postcode"
							all_valid = false
						end 
					else
						flash[:error] = "Please enter an address"
						all_valid = false
					end
				else
					all_valid = true
				end 
			else
				flash[:error] = "Please enter a valid email"
				all_valid = false
			end			
			if all_valid
				session[:guest] = params[:session][:email]	# keep the guest email until ready to pay
				session[:address_1] = params[:session][:address_1]
				session[:address_2] = params[:session][:address_2]
				session[:town] = params[:session][:town]
				session[:county] = params[:session][:county]
				session[:postcode] = params[:session][:postcode]
				session[:country] = params[:session][:country]
				redirect_back_or @user
			else
				hash = {from: "checkout"}	# need to keep track of where they came from
				if cart_needs_address
					hash[:addy] = "need"
				end 
				not_signed_in_user (hash)	# send them back to the sign-in form
			end
		else
			user = User.find_by_user_name(params[:session][:user_name])
			if user && user.authenticate(params[:session][:password]) 
				# SessionsHelper functions...
				#	sign_in 1) sets the cookies remember_token  2) sets current_user
				sign_in user
				if cart_needs_address && !user.have_address?
					# session[:return_to] should already be set...?
					hash = {from: "checkout", id: user.id.to_s}
					redirect_to editdetails_path(hash)  #, notice: "Please sign in."				
				else
					#	redirect_back_or 1) redirects to previously stored location OR default (user)
					redirect_back_or user
				end
			else
				flash.now[:error] = "Invalid email/password combination"
				render 'new', layout: "processing"
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
		render layout: "processing"
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
		render "cart", layout: "processing"
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
					if cart_needs_address
						@user.address_1 = session[:address_1]
						@user.address_2 = session[:address_2]
						@user.town = session[:town]
						@user.county = session[:county]
						@user.postcode = session[:postcode]
						@user.country = session[:country]
					end if
					@user.save	# we are finally at the point where we must save the guest, so they can pay
					current_user = @user
				end
				
				@action = "checkout"

				# if we reach this point, we can trash the session stored guest
				# so that if the guest continues shopping they won't have their email stored
				session.delete(:guest)
				session.delete(:address_1)
				session.delete(:address_2)
				session.delete(:town)
				session.delete(:county)
				session.delete(:postcode)
				session.delete(:country)

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
				render "cart", layout: "processing"
			else
				hash = {from: "checkout"}
				# also must decide whether to require the address fields
				if cart_needs_address
					hash[:addy] = "need"
				end 
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

	def cart_needs_address
		@cart.each do |cart_item|
			product = Product.find(cart_item[:product_id])
			if product.format = "Paper"
				return true
			end
		end
		return false
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
