class PurchasesController < ApplicationController
	include PurchaseHandler

	before_filter :admin_user, only: [:index, :edit, :new, :destroy]
	before_filter :check_for_cancel, only: [:update]
	
	def index
		@purchases = Purchase.paginate(page: params[:page])
		@purchase = Purchase.new
		render layout: pick_layout
	end

	def show
		@purchase = Purchase.find(params[:id])
		render layout: pick_layout
	end

	def new
		@purchase = Purchase.new
		render layout: pick_layout
	end

	def create
	end

	def handle_payment
		if session[:cart].length == 0 
			redirect_to "/cart"
		else			
			@purchase = Purchase.new
			@cart = session[:cart]
			create_purchase @purchase, @cart
			
			# when testing paypal link, uncomment this section
			# @paypal_link = generate_paypal_link
			# flash[:error] = @paypal_link	# for testing
			# redirect_to "/checkout"		# for testing

			# when testing paypal link, comment out this section
			if @purchase.save 
				@paypal_link = generate_paypal_link
				redirect_to @paypal_link
			else
				flash[:error] = "There was an error with your purchase"
				redirect_to "/cart"
			end
		end		
	end 
	
	def edit
		@purchase = Purchase.find(params[:id])
		render layout: pick_layout
	end
	
	def update
	end
	
	def destroy
		@purchase = Purchase.find(params[:id])
		@purchase.destroy
		flash[:success] = "Purchase destroyed."
		redirect_to purchases_path
	end

	private
	
	def admin_user
		redirect_to root_path unless current_user.admin?
	end
	def check_for_cancel
		if params[:commit] == "Cancel"
			redirect_to hunts_path
		end
	end
end
