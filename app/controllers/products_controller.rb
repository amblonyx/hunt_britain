class ProductsController < ApplicationController
	before_filter :admin_user, only: [:destroy, :edit, :update, :create, :new]

	def index
		@products = Product.paginate(page: params[:page])
		@product = Product.new
		render layout: pick_layout
	end

	def show
		@product = Product.find(params[:id])
		render layout: pick_layout
	end

	def new
		render layout: pick_layout
	end

	def create
		@product = Product.new(params[:product])
		@product.location = Location.find_by_id(params[:location_id])
		if @product.save 
			flash[:success] = "The new product has been saved"
			redirect_to @product.location
		else
			render 'new', layout: pick_layout
		end
	end

	def edit
		@product = Product.find(params[:id])
		render layout: pick_layout
	end
	
	def update
		@product = Product.find(params[:id])
		if @product.update_attributes(params[:product])
			flash[:success] = "Update successful"
			redirect_to @product.location
		else
			render 'edit', layout: pick_layout
		end
	end
	
	private

	def admin_user
		redirect_to root_path unless current_user.admin?
	end

end
