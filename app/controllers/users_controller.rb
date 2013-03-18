class UsersController < ApplicationController
#	before_filter :check_for_cancel, :only => [:create, :update]
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: [:index, :destroy]
	before_filter :clear_state
	 
	def index
		@users = User.paginate(page: params[:page])
		render layout: pick_layout
	end
	
	def show 
		@user = User.find(params[:id])
		if params[:email] == "welcome"
			send_welcome_email
		end
		render layout: pick_layout
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

		@user = User.new(params[:user])

		if @user.save 
			# Tell the UserMailer to send a welcome Email after save
			#-----UserMailer.welcome_email(@user).deliver
			sign_in @user
			flash[:success] = "Welcome to Hunt Britain"
			redirect_back_or(@user)
		else
			render 'new', layout: pick_layout
		end

#		respond_to do |format|
#			if @user.save 
				# Tell the UserMailer to send a welcome Email after save
				#-----UserMailer.welcome_email(@user).deliver
#				sign_in @user
#				flash[:success] = "Welcome to Hunt Britain"
#				format.html { redirect_back_or(@user) }
#				format.json { render json: @user, status: :created, location: @user }
#			else
#				format.html { render action: 'new' }
#				format.json { render json: @user.errors, status: :unprocessable_entity }			
#			end
#		end
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
				# I don't know why, but update_attributes seems to sign out the user, so...
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
		@user = User.find(params[:id])
		UserMailer.welcome_email(@user).deliver
		
		flash[:success] = "Sent"
		redirect_to @user
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
	
	def check_for_cancel
#		if params[:commit] == "Cancel"
#			if action = "create"
#				redirect_back_or root_path
#			else
#				redirect_back_or current_user
#			end
#		end
	end

end
