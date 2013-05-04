class PurchasesController < ApplicationController
    include PurchasesHelper
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
		@purchase = Purchase.new
		create_payment @purchase, params
		if @purchase.save 
			flash[:success] = "The new purchase has been saved"
			
			# Temporary - while testing
			#-- redirect_to @purchase

			# Inform user that payment was successful
			redirect_to payment_success_path + "?reference=" + @purchase.reference
						
			# Send a confirmation email for purchase
			UserMailer.confirm_purchase(@purchase).deliver
			UserMailer.deliver_purchases(@purchase).deliver

		else
			render 'show', layout: pick_layout
		end
	end

	def handle_payment
		
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
