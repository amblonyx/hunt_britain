class LocationsController < ApplicationController
	
	def index
		@locations = Location.paginate(page: params[:page])
	end
	
	def show 
		@location = Location.find(params[:id])
		@products = @location.products.where(['id is not null'])		
		@product = @location.products.new
	end

	def new
		@location = Location.new
	end
	def create
		@location = Location.new(params[:location])
		if @location.save 
			flash[:success] = "The new location has been saved"
			redirect_to @location
		else
			render 'new'
		end
	end

end
