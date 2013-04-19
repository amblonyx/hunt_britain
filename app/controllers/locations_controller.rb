class LocationsController < ApplicationController
	before_filter :admin_user, only: [:destroy, :edit, :update, :create, :new]
	
	def home
		@locations = Location.all
		render layout: pick_layout
	end
	
	def index
		@locations = Location.paginate(page: params[:page])
		render layout: pick_layout
	end
	
	def show
		@location = Location.find(params[:id])
		@products = @location.products.where(['id is not null'])		
		@product = @location.products.new
		render layout: pick_layout
	end
	
	def new
		@location = Location.new
		render layout: pick_layout
	end
	
	def create
		@location = Location.new(params[:location])
		if @location.save 
			flash[:success] = "The new location has been saved"
			redirect_to @location
		else
			render 'new', layout: pick_layout
		end
	end

	def edit
		@location = Location.find(params[:id])
		@products = @location.products.where(['id is not null'])		
		@product = @location.products.new
		render layout: pick_layout	
	end

	def update
		@location = Location.find(params[:id])
		if @location.update_attributes(params[:location])
			flash[:success] = "Update successful"
			redirect_to @location
		else
			render 'edit', layout: pick_layout
		end
	end

	private
	
	def admin_user
		redirect_to root_path unless current_user.admin?
	end
	
end
