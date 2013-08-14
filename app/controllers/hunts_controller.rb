class HuntsController < ApplicationController
	before_filter :admin_user, only: [:index, :edit, :create, :new, :destroy, :change_voucher, :restart_hunt]
	before_filter :check_for_cancel, only: [:create, :update]
	
	def index
		@sort_fields = [["Product name","products.name"], ["User email","users.email"], ["Voucher code","voucher_code"], ["Started at", "started_at"],["Last submitted", "last_submitted"]]
		
		if params.has_key?("search")
			@filter = params[:filter]
			@sort = params[:sort]
		else
			@filter = Hash.new
			@filter = {"status_fresh" => "1", "status_on_going" => "1", "status_paused" => "1", "status_completed" => "1" }
			@sort = Hash.new
		end
		@hunts = Hunt.filtered(@filter, @sort)		
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
		@page_title = "Enter voucher code"

		if !honeypot #Catch BOTS.  In ApplicationHelper
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
				load_cart	# for correct header display
				@hunt = Hunt.new
				render "hunt_login"
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
	
		# Set team name if it hasn't already been set
		if params[:submit_team_name] 
			if @hunt.team_name.blank?
				if @hunt.update_attributes(params[:hunt])
					redirect_to_hunt_home @hunt
				else
					render 'set_team_name'
				end		
			else
				redirect_to_hunt_home @hunt
			end

		# Start the hunt
		elsif params[:submit_start_hunt]
			if !@hunt.started?
				@hunt.start
				set_hunter
				redirect_to_hunt_home @hunt
			else
				redirect_to_hunt_home @hunt
			end
			
		# Team stats
		elsif params[:submit_stats]
			# Retrieve all the hunts in the group
			@hunts_in_group = get_hunts_in_group
			
			if @hunts_in_group.length > 0
				@popup_header = "Team stats"
				@popup_type = "popup"
				@popup_action = "stats"
				render "popup_handler.js" 	
			else
				render "reload.js"
			end 
		else 
			# If we're the hunt leader....
			if is_hunter?
			
				# There are a lot of actions that could be taken, submitting a clue answer is the final "else"
				if params[:submit_peek]
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
					redirect_to_hunt_home @hunt
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

						if huntxml.xpath("//style").inner_html == "elimination"
							opt = "option_" + @hunt.current_clue.to_s
						else
							#-- Parameter being returned is "option_#" where # is the position of the (clicked) answer within the node set (starting at 0)
							correct_node = @clue_node.xpath("options/option[@correct='1']").first
							correct_posn = correct_node.parent.children.index(correct_node).to_s
							opt = "option_" + correct_posn
						end
						
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
			# If we're NOT the hunt leader....
			else
				if @hunt.paused?
					if params[:submit_resume]	# resume after a pause by just triggering a reload
						@popup_header = "Are you sure?"
						@popup_content = "You will replace the current leader."
						@popup_action = "makehunter"
						@popup_type = "popup_confirm"
						render "popup_handler.js" 
					elsif params[:submit_continue]	# this is used if they re-view the instructions then continue
						redirect_to_hunt_home @hunt
					elsif params[:submit_cancel]	# from a popup with OK/Cancel buttons
						render "cancel.js"	
					elsif params[:submit_ok]	 # Confirm, make me the hunter (OK)
						if params[:popaction] == "makehunter"
							set_hunter
							@hunt.resume_hunt
						end
						render "reload.js"
					else
						@popup_header = "Time out"
						@popup_content = "The hunt has been paused."
						@popup_type = "popup"
						@popup_action = "reload"
						render "popup_handler.js" 	
					end
				elsif !@hunt.started?
					if params[:submit_continue]	# this is used if they re-view the instructions then continue
						redirect_to_hunt_home @hunt
					else
						render "reload.js"
					end
				elsif params[:submit_next] # See the next clue
					if params[:current_clue] == @hunt.current_clue.to_s		
						@popup_header = "You can't go on!"
						@popup_content = "This clue hasn't been answered yet."
						@popup_type = "popup"
						render "popup_handler.js" 
					else
						render "reload.js"
					end 
				elsif params[:submit_answer] # Make me the hunter
					@popup_header = "Are you sure?"
					@popup_content = "You will replace the current leader."
					@popup_action = "makehunter"
					@popup_type = "popup_confirm"
					render "popup_handler.js" 
				elsif params[:submit_ok]	 # Confirm, make me the hunter (OK)
					if params[:popaction] == "makehunter"
						set_hunter
						if @hunt.paused?
							@hunt.resume_hunt
						end
					end
					render "reload.js"
				elsif params[:submit_cancel]	# from a popup with OK/Cancel buttons
					render "cancel.js"		
				elsif params[:submit_resume]	# resume after a pause by just triggering a reload
					render "reload.js"			
				elsif params[:submit_continue]	# this is used if they re-view the instructions then continue
					redirect_to_hunt_home @hunt
				elsif params[:submit_start_hunt]
					redirect_to_hunt_home @hunt
				else
					@popup_header = "You can't do this..."
					@popup_content = "Someone else has taken over as the leader of this hunt."
					@popup_action = "reload"
					@popup_type = "popup"
					render "popup_handler.js" 
				end
			end
		end 
	end
	
	def show_intro
		render "hunt_intro", layout: "hunt"
	end

	private

	def redirect_to_hunt_home(hunt)
		redirect_to "/hunt_home/#{hunt.id.to_s}"
	end 
	
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
	
	def load_cart
		if not session.has_key? :cart
			session[:cart] = Array.new
		end
		@cart = session[:cart]
	end
end
