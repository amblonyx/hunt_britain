class UsersController < ApplicationController
#	before_filter :check_for_cancel, :only => [:create, :update]
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: [:index, :destroy]
	before_filter :load_cart
	before_filter :clear_state
	 
	def index
		@sort_fields = [["User name","user_name"], ["Email","email"], ["Name","name"]]
		
		if params.has_key?("search")
			@filter = params[:filter]
			@sort = params[:sort]
		else
			@filter = Hash.new
			@filter = {"guest" => "1", "admin" => "1", "registered" => "1" }
			@sort = Hash.new
		end
		@users = User.filtered(@filter, @sort)
		render layout: pick_layout
	end
	
	def show 
		@user = User.find(params[:id])
		if params[:email] == "welcome"
			send_welcome_email
			redirect_to @user
		else
			render layout: pick_layout
		end
	end

	def new
		@user = User.new
		render layout: pick_layout
	end
	
	def create
		if params[:commit] == "Cancel"
			redirect_back_or(root_path) 
			return
		end
		if !params[:honey].blank?
			flash[:error] = "Are you a BOT?"
			redirect_back_or(root_path) 
			return
		end

		@user = User.new(params[:user])

		if @user.save 
			sign_in @user
			flash[:success] = "Welcome to Hunt Britain"
			send_welcome_email
			redirect_back_or(@user)
		else
			flash[:error] = @user.errors.first
			render 'new', layout: pick_layout
		end
	end

	def edit
		@user = User.find(params[:id])
		set_state	# need to keep location and addy for upd
		render layout: pick_layout
	end
	
	def update
		if params[:commit] == "Cancel"
			redirect_back_or(current_user) 
			return
		end
		
		@user = User.find(params[:id])
		if need_address? && params[:user][:address_1].blank? && params[:user][:postcode].blank?
			flash[:error] = "Please provide an address"
			set_state	# keep location and need address
			render 'edit', layout: pick_layout 
		else
			if @user.update_attributes(params[:user])
				flash[:success] = "Profile updated"
				# I don't know why yet, but update_attributes seems to sign out the user, so...
				sign_in @user
				# Back to show user, or to checkout if recording address from there
				redirect_back_or @user
			else
				set_state
				render 'edit', layout: pick_layout
			end
		end
	end
  
	def destroy 
		@user = User.find(params[:id])
#		if !correct_user?(@user)
#			User.find(params[:id]).destroy
#			flash[:success] = "User destroyed."
#			redirect_to users_path
#		else
#			redirect_to @user		
#		end
	end
	
	def send_welcome_email 
		UserMailer.welcome_email(@user).deliver
		flash[:success] = "Email sent"
	end
	
	def download 
		@user = User.find(params[:id])
		@product = Product.find(params[:pid])
		send_file  "#{DOWNLOAD_PATH}#{@product.data_file}", filename: @product.data_file,  type: "application/pdf", disposition: 'attachment'
		flash[:notice] = "Your file has been downloaded"
	end 
	
	private
	
	def signed_in_user
		redirect_to signin_path, notice: "Please sign in" unless signed_in?
	end
	
	def correct_user
		@user = User.find(params[:id])
		redirect_to root_path unless correct_user?(@user)
	end
	
	def admin_user
		redirect_to root_path unless current_user.admin?
	end

	def load_cart
		if not session.has_key? :cart
			session[:cart] = Array.new
		end
		@cart = session[:cart]
	end
end
