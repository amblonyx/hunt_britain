class HuntsController < ApplicationController
	
	def index
		@hunts = Hunt.paginate(page: params[:page])
	end

	def show
		@hunt = Hunt.find(params[:id])
		
		if params[:p] == "intro"
			show_intro
		elsif @hunt.completed?
		
		elsif @hunt.started?
			if @hunt.current_status == "Passed"
				render "hunt_answer", layout: "hunt"
			else
				render "hunt_clue"			
			end
		elsif @hunt.team_name.blank?
			render "set_team_name"
		else
			show_intro
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

		if params[:submit_team_name]
			if @hunt.update_attributes(params[:hunt])
				flash[:success] = "Hunt details updated"
				#sign_in @user
				redirect_to @hunt
			else
				render 'set_team_name'
			end		
		elsif params[:submit_start_hunt]
			start_hunt
			redirect_to @hunt
		elsif params[:submit_pass]
			pass_on_clue
			redirect_to @hunt		
		elsif params[:submit_resume]
			redirect_to @hunt				
		else
			render "show"
		end
		
	end
	
	def show_intro
		render "hunt_intro"
	end

	private
		def create_voucher_code
			if params[:voucher_code].blank? 
				@hunt.voucher_code = SecureRandom.hex(5) 
			end
		end
		def start_hunt
			@hunt.started = true
			@hunt.started_at = Time.now
			@hunt.current_clue = 1
			@hunt.current_status = "Fresh"
			
			@hunt.paused = false
			@hunt.completed = false
			@hunt.time_taken = 0
			@hunt.last_submitted = nil 
			
			@hunt.save
		end
		def pass_on_clue
			@hunt.current_status = "Passed"
			@hunt.last_submitted = Time.now 
			@hunt.save
		end
end
