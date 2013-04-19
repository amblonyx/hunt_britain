module SessionsHelper

	# let and set...  @current_user is local variable
	def current_user=(user)
		@current_user = user
	end
	
	def current_user
		# if current_user is NOT nil, set it using remember_token
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end
	
	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end
	
	def correct_user?(user)
		user == current_user
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
		cookies.delete(:guest)
	end

	def identified?
		!current_user.nil? || !session[:guest].blank?
	end
	
	def signed_in?
		!current_user.nil? 
	end
	
	def pick_layout
		if current_user.nil? || !current_user.admin?
			return "application"
		else
			return "admin"
		end
	end
#	def make_guest_user
#		user = User.new
#		user.create_as_guest session[:guest]
#		session.delete(:guest)	# so their email isn't stored if they leave the page
#		user
#	end
	
#	def not_signed_in_user #(params)
#		unless signed_in?
#			store_location
#			redirect_to signin_path #(params)#, notice: "Please sign in."
#		end
#	end
	
#	def user_has_no_address(params)
#		unless current_user.have_address?
#			store_location
#			redirect_to edit_user_path(params)#, notice: "Please enter an address" 
#		end
#	end
	
end
