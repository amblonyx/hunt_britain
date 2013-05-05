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
			
			if @purchase.save 
				@paypal_link = generate_paypal_link
				
#				flash[:success] = "The new purchase has been saved"
#
#				# Inform user that payment was successful
#				redirect_to payment_success_path + "?reference=" + @purchase.reference
#							
#				# Send a confirmation email for purchase
#				UserMailer.confirm_purchase(@purchase).deliver
#				# Deliver online and PDF hunts
#				UserMailer.deliver_purchases(@purchase).deliver
#				return

				session[:cart] = Array.new
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
#		@purchase = Purchase.find(params[:id])
#		if @purchase.update_attributes(params[:purchase])
#			flash[:success] = "Update successful"
#			redirect_to @purchase.location
#		else
			render 'edit', layout: pick_layout
#		end
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
