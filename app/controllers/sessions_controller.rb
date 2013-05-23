class SessionsController < ApplicationController
	before_filter :load_cart
	before_filter :clear_state	# in app helper

	def new			
		@user = User.new
		@mode = params[:mode]
		set_state	# keep state if we're here from checkout
		render layout: pick_layout
	end
	
	def create
		@mode = params[:mode]
		if !params[:honey].blank?
			# BOT alert!
			flash[:error] = "Are you a BOT?"
			redirect_to root_path
			return
		end
		if params.has_key?(:reset_password)
			@user = User.find_by_user_name(params[:session][:user_name])
			if @user 
				@user.create_password_token
				@user.save
				
				#-- send email to user
				UserMailer.reset_password(@user).deliver
				flash[:success] = "We've sent an email to #{@user.email} with the link to reset the password. "
				redirect_to new_session_path
			else
				flash[:error] = "Invalid email address"
				redirect_to signin_path(mode: "forgot_password")
			end 
		else
			@user = User.new
			if params[:guest_user]
				if @user.is_valid_email?(params[:session][:email])
					if need_address?
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
					redirect_to return_to
				else
					set_state	# keep track of location and need address
					redirect_to signin_path
				end
			else
				user = User.find_by_user_name(params[:session][:user_name])
				if user && user.authenticate(params[:session][:password]) 
					# SessionsHelper functions...
					#	sign_in 1) sets the cookies remember_token  2) sets current_user
					sign_in user
					set_state	# keep location and need for addy
					redirect_back_or user
				else
					flash[:error] = "Invalid email/password combination"
					set_state	# keep location and need for addy
					#redirect_to signin_path
					render "new", layout: pick_layout
				end
			end
		end 
	end
	
	def destroy
		sign_out
		redirect_back_or root_path
	end

	def checkout
		if @cart.length == 0 
			redirect_to "/cart"
		else
			set_return_to("/checkout")	# make note that we're in the checkout process
			if identified?
				if signed_in?
					@user = current_user
					if cart_needs_address && !@user.have_address?
						need_address("yes")
						hash = {id: @user.id.to_s}
						set_state	# keep track of where we are and need for address
						redirect_to editdetails_path(hash)  		
						return	# so the action stops here
					end
				else
					@user = User.new
					@user.create_as_guest session[:guest]
					session.delete(:guest)	# so their email isn't stored if they leave the page
					if cart_needs_address
						@user.address_1 = session[:address_1]
						@user.address_2 = session[:address_2]
						@user.town = session[:town]
						@user.county = session[:county]
						@user.postcode = session[:postcode]
						@user.country = session[:country]
					end 
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

				@paypal_link = handle_payment_path
				
				render "cart", layout: pick_layout
			else
				# also must decide whether to require the address fields
				if cart_needs_address
					need_address("yes")
				else
					need_address("no")
				end
				set_state	# to remember where we are and need address
				redirect_to signin_path
			end
		end
	end
	
	def cart
		@action = "cart"
		render layout: pick_layout
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
				if value.to_i.to_s != value.to_s			# check for non-integer value
					flash[:error] = "Invalid quantity entered"
					redirect_to "/cart"
					return
				elsif value.to_i > 20
					flash[:error] = "You should not need more than 20 copies!"
					redirect_to "/cart"
					return				
				else
					cart_items.first[:num] = value
				end
			end 
		end
		# remove items where quantity have been set to zero
		@cart.reject! { |item| item[:num].to_i == 0  }

		redirect_to "/cart"
	end
	
	def reset_password
		if !params[:honey].blank?
			# BOT alert!
			flash[:error] = "Are you a BOT?"
			redirect_to root_path
			return
		end

		# Link should contain token
		if params.has_key?(:token)
			@token = params[:token]
			@user = User.find_by_token(@token)
			
			if @user 
				if !params[:password].blank? && !params[:confirm_password].blank?
					if params[:password] == params[:confirm_password]
						# Update password
						@user.password = params[:password]
						@user.token = nil
						@user.save
						sign_in @user
						
						flash[:success] = "Your password has been updated.  Welcome back."
						redirect_to @user
						return
					else	
						flash[:error] = "The entries in the password and confirmation fields did not match"
						render layout: pick_layout
						return
					end 
				else
					render layout: pick_layout
					return
				end 
			end
		end 
		redirect_to new_session_path(mode: "forgot_password")
	end
	

	private
	
	def load_cart
		if not session.has_key? :cart
			session[:cart] = Array.new
		end
		@cart = session[:cart]
	end

	def cart_needs_address
		has_purchase_format(@cart, "Paper")
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
