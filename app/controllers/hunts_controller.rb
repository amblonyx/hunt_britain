class HuntsController < ApplicationController
	before_filter :admin_user, only: [:index, :edit, :create, :new, :destroy, :change_voucher, :restart_hunt]
	before_filter :check_for_cancel, only: [:create, :update]
	
	def index
		@hunts = Hunt.paginate(page: params[:page])
		render layout: pick_layout
	end

	def show
	
	end
	
	def new
		@hunt = Hunt.new
		render layout: pick_layout
	end
	  
	def create
		@hunt = Hunt.new(params[:hunt])
		if @hunt.save 
			flash[:success] = "The new hunt has been saved"
			redirect_to hunts_path
		else
			render 'new', layout: pick_layout
		end
	end

	def edit
		@hunt = Hunt.find(params[:id])
		render layout: pick_layout	
	end

	def update
		@hunt = Hunt.find(params[:id])
		if @hunt.update_attributes(params[:hunt])
			flash[:success] = "Update successful"
			redirect_to hunts_path
		else
			render 'edit', layout: pick_layout
		end
	end
	
	def destroy
		@hunt = Hunt.find(params[:id])
		@hunt.destroy
		redirect_to hunts_path
	end
	
	def change_voucher
		@hunt = Hunt.find(params[:id])
		change_voucher_code
		if @hunt.save 
			flash[:success] = "Voucher code has been changed"
			redirect_to hunts_path
		else
			flash[:error] = "Error while changing voucher code"
			render 'index', layout: pick_layout
		end
	
	end 
	
	def restart_hunt
		@hunt = Hunt.find(params[:id])
		@hunt.restart
		if @hunt.save 
			flash[:success] = "Hunt status changed"
			redirect_to hunts_path
		else
			flash[:error] = "Error while restarting hunt"
			render 'index', layout: pick_layout
		end

	end 
	
	def hunt_login
		if !honeypot #Catch BOTS.  In applicationHelper
			if params.has_key?(:voucher)
				voucher = params[:voucher]
				@hunt = Hunt.find_by_voucher_code(voucher)
				if @hunt
					sign_in_voucher(@hunt)
					redirect_to '/hunt_home/' + @hunt.id.to_s, layout: "hunt"
					return
				else
					flash[:error] = "Voucher code was not found"
					redirect_to '/hunt_login/'
				end
			else
				@hunt = Hunt.new
				render "hunt_login", layout: "hunt"
			end
		end
	end
	
	def hunt_home
	
		@hunt = Hunt.find_by_id(params[:id])
		
		if @hunt.nil?
			flash[:error] = "Invalid hunt"
			redirect_to hunt_login_path
			return
		end
		unless correct_hunt?(@hunt)
			redirect_to hunt_login_path
			return
		end

		if params[:p] == "intro"	# this is for showing instructions
			show_intro
		elsif @hunt.completed?
			render "hunt_complete", layout: "hunt"
		elsif @hunt.paused?
			render "hunt_paused", layout: "hunt"
		elsif @hunt.started?
			render "hunt_clue", layout: "hunt"
		elsif @hunt.team_name.blank?
			render "set_team_name", layout: "hunt"
		else
			show_intro
		end
	end

	def hunt_trail
	
		@hunt = Hunt.find(params[:id])
	
		# There are a lot of actions that could be taken, submitting a clue answer is the final "else"
		if params[:submit_team_name]
			if @hunt.update_attributes(params[:hunt])
				redirect_to '/hunt_home/' + @hunt.id.to_s
			else
				render 'set_team_name'
			end		
		elsif params[:submit_start_hunt]
			@hunt.start
			redirect_to '/hunt_home/' + @hunt.id.to_s
		elsif params[:submit_peek]
			render "peek.js" 
		elsif params[:submit_hint]
			@hunt.take_hint
			render "hint.js" 
		elsif params[:submit_pass]
			render "pass.js" 
		elsif params[:submit_pause]		# pause the hunt for a break
			@hunt.pause_hunt
			render "reload.js"			# will redirect to the paused page
		elsif params[:submit_problem]
			render "problem.js"
		elsif params[:submit_restart]
			render "restart.js" 
		elsif params[:submit_ok]		# from a popup with OK/Cancel buttons
			if params[:popaction] == "giveup"
				@hunt.pass_on_clue
				render "giveup.js"
			else	# restart is the only other action
				@hunt.restart
				@hunt.save 
				render "reload.js"
			end
		elsif params[:submit_cancel]	# from a popup with OK/Cancel buttons
			render "cancel.js"		
		elsif params[:submit_resume]	# resume after a pause by just triggering a reload
			@hunt.resume_hunt
			render "reload.js"
		elsif params[:submit_continue]	# this is used if they re-view the instructions then continue
			redirect_to '/hunt_home/' + @hunt.id.to_s
		elsif params[:submit_problem_feedback]	# if they submit feedback in the popup
			UserMailer.problem_email(@hunt, params[:current_clue], params[:problem]).deliver
			flash[:success] = "Thanks for your feedback!"
			render "reload.js"		# flash won't appear unless we reload
		elsif params[:submit_problem_cancel]
			render "cancel.js"
		else	# it is an attempted answer, so check it
			if params[:current_clue] == @hunt.current_clue.to_s		# this prevents double-clicks answering 2 clues
				f = File.open( XML_PATH + "products/#{@hunt.product.data_file}.xml" )
				huntxml = Nokogiri::XML(f)
				f.close
				@clue_node = huntxml.xpath("//clues/clue[@number='#{@hunt.current_clue}']")
				
				#-- Parameter being returned is "option_#" where # is the position of the (clicked) answer within the node set (starting at 0)
				correct_node = @clue_node.xpath("options/option[@correct='1']").first
				correct_posn = correct_node.parent.children.index(correct_node).to_s
				opt = "option_" + correct_posn
				if params.has_key?(opt.to_sym)	# then the right answer was submitted
					@hunt.right_answer
					render "answer.js"
				else
					@hunt.wrong_answer	
					render "wrong.js"
				end
			else
				return
			end
		end

	end
	
	def show_intro
		render "hunt_intro", layout: "hunt"
	end

	private

	def change_voucher_code
		@hunt.voucher_code = SecureRandom.hex(5) 
	end
	
	def admin_user
		redirect_to root_path unless current_user.admin?
	end
	def check_for_cancel
		if params[:commit] == "Cancel"
			redirect_to hunts_path
		end
	end
end
