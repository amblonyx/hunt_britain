class UsersController < ApplicationController
	def index
		@users = User.paginate(page: params[:page])
	end
	
	def show 
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end
	
	def create
		@user = User.new(params[:user])
		if @user.save 
			#sign_in @user
			flash[:success] = "Welcome to the Sample App"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
	end
	
	def update
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
end
