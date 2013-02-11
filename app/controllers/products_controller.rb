class ProductsController < ApplicationController
	def index
	end

	def show
		@product = Product.find(params[:id])
	end

	def new
	end
	
	def create
		@product = Product.new(params[:product])
		@product.location = Location.find_by_id(params[:location_id])
		if @product.save 
			flash[:success] = "The new location has been saved"
			redirect_to @product.location
		else
			render 'new'
		end
	end

end
