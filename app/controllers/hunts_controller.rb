require 'XMLHandler'
class HuntsController < ApplicationController

	include XMLHandler
	#before_save :create_voucher_code, only: [:create]
	
	
	def index
		@hunts = Hunt.paginate(page: params[:page])
	end

	def show
		@hunt = Hunt.find(params[:id])
		
		if @hunt.completed?
		
		elsif @hunt.started?
		
		elsif @hunt.team_name.blank?
			render "set_team_name"
		else
			render "hunt_intro", xml: get_product_XML
		end
	end

	def new
		@hunt = Hunt.new
	end
	  
	def create
		@hunt = Hunt.new(params[:hunt])
		create_voucher_code
		if @hunt.save 
			flash[:success] = "The new hunt has been saved"
			redirect_to @hunt
		else
			render 'new'
		end
	end

	def update
		@hunt = Hunt.find(params[:id])
		if @hunt.update_attributes(params[:hunt])
			flash[:success] = "Hunt details updated"
			#sign_in @user
			redirect_to @hunt
		else
			render 'edit'
		end		
	end

	private
		def create_voucher_code
			if params[:voucher_code].blank? 
				@hunt.voucher_code = SecureRandom.hex(5) 
			end
		end
		
		def get_product_XML
			load_xml ("#{@hunt.product.data_file}.xml").to_s.html_safe 
		end
end
