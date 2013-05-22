class ProductsController < ApplicationController
	before_filter :admin_user, only: [:destroy, :edit, :update, :create, :new]
	before_filter :check_for_cancel, only: [:create, :update]

	def index
		if params.has_key?("search")
			#@products = Product.paginate(page: params[:page])

			@products = Product.filtered(params[:product])			
			@product = Product.new(params[:product])
		else
			@products = Product.all
			@product = Product.new
		end
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
	def check_for_cancel
		if params[:commit] == "Cancel"
			redirect_to products_path
		end
	end
end
