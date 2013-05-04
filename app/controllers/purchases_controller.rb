class PurchasesController < ApplicationController
    include PurchasesHelper
	before_filter :load_cart
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
		if params[:item_number1] && !params[:item_number1].empty?
			#paypal sends an IPN even when the transaction is voided.
			#save the payment status along with the amount of the transaction.
			if params[:payment_status] != 'Voided'
			
				@purchase = Purchase.new
				create_payment @purchase, params
				if @purchase.save 
					flash[:success] = "The new purchase has been saved"

					# Inform user that payment was successful
					redirect_to payment_success_path + "?reference=" + @purchase.reference
								
					# Send a confirmation email for purchase
					UserMailer.confirm_purchase(@purchase).deliver
					# Deliver online and PDF hunts
					UserMailer.deliver_purchases(@purchase).deliver
					return
				end
				
			end 
		end
	end

	def handle_payment
		if params.has_key?(:VERIFIED)
			flash[:success] = "Payment made"
		elsif params.has_key?(:INVALID)
			flash[:error] = "Invalid"
		else
			@paypal_verify = "https://www.sandbox.paypal.com/cgi-bin/webscr?" + "cmd=_notify-validate&" + request.query_string
			#flash[:success] = @paypal_verify
			redirect_to @paypal_verify
		end		
		
		#redirect_to root_path
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
	def load_cart
		if not session.has_key? :cart
			session[:cart] = Array.new
		end
		@cart = session[:cart]
	end
end
