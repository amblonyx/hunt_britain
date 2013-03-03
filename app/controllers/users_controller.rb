class UsersController < ApplicationController
	def index
		@users = User.paginate(page: params[:page])
	end
	
	def show 
		@user = User.find(params[:id])
		if params[:email] == "welcome"
			send_welcome_email
		end
	end

	def new
		@user = User.new
	end
	
	def create
		@user = User.new(params[:user])
		
		respond_to do |format|
			if @user.save 

				# Tell the UserMailer to send a welcome Email after save
				UserMailer.welcome_email(@user).deliver
		 
				sign_in @user
				flash[:success] = "Welcome to the Sample App"
				format.html { redirect_back_or(@user, notice: 'User was successfully created.') }
				format.json { render json: @user, status: :created, location: @user }
				
			else
				format.html { render action: 'new' }
				format.json { render json: @user.errors, status: :unprocessable_entity }			end
		end
	end

	def edit
		@user = User.find(params[:id])
	end
	
	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated"
			#sign_in @user
			redirect_to @user
		else
			render 'edit'
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
end
