module SessionsHelper

	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end
	def remember_guest(email)
		cookies[:guest] = email
		cookies[:remember_token] = "guest"
	end
	def identified?
		!current_user.nil? || !session[:guest].blank?
	end
	def signed_in?
		!current_user.nil? 
	end
	def guest_user
		user = User.new
		user.create_as_guest session[:guest]
		session.delete(:guest)	# so their email isn't stored if they leave the page
		user
	end
	def correct_user?(user)
		user == current_user
	end
	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
		cookies.delete(:guest)
	end
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end
	def store_location
		session[:return_to] = request.fullpath
	end
	def has_address?
		current_user.address_1.blank? or current_user.postcode.blank?
	end
	
	def not_signed_in_user(params)
		unless signed_in?
			store_location
			redirect_to signin_path(params)#, notice: "Please sign in."
		end
	end
	def user_has_no_address(params)
		unless has_address?
			store_location
			redirect_to edit_user_path(params)#, notice: "Please enter an address" 
		end
	end
	
	# let and set...  @current_user is local variable
	def current_user=(user)
		@current_user = user
	end
	def current_user
		# if current_user is NOT nil, set it using remember_token
		@current_user  ||= User.find_by_remember_token(cookies[:remember_token])
	end
	
end
