class HuntsController < ApplicationController
	before_filter :admin_user, only: [:index, :edit, :create, :new]
	
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
		create_voucher_code
		if @hunt.save 
			flash[:success] = "The new hunt has been saved"
			redirect_to @hunt.product
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
			redirect_to @hunt
		else
			render 'edit', layout: pick_layout
		end
	end
	
	def hunt_login
		if params.has_key?(:voucher)
			voucher = params[:voucher]
			@hunt = Hunt.find_by_voucher_code(voucher)
			if @hunt
				sign_in_voucher(@hunt)
				redirect_to '/hunt_home/' + @hunt.id.to_s
				return
			else
				flash[:error] = "There is an error with this voucher"
			end
		else
			@hunt = Hunt.new
			render "hunt_login"
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
		
		if params[:submit_team_name]
			if @hunt.update_attributes(params[:hunt])
				flash[:success] = "Hunt details updated"
				redirect_to '/hunt_home/' + @hunt.id.to_s
			else
				render 'set_team_name'
			end		
		elsif params[:submit_start_hunt]
			@hunt.start
			@hunt.save
			redirect_to '/hunt_home/' + @hunt.id.to_s
		elsif params[:submit_hint]
			@hunt.add_penalty 2
			@hunt.save
			render "hint.js" 
		elsif params[:submit_pass]
			render "pass.js" 
		elsif params[:submit_giveup]
			@hunt.pass_on_clue
			@hunt.save
			render "giveup.js"
		elsif params[:submit_nogiveup]
			render "nogiveup.js"		
		elsif params[:submit_peek]
			render "peek.js" 
		elsif params[:submit_pause]		# pause the hunt for a break
			@hunt.pause_hunt
			@hunt.save
			render "reload.js"
		elsif params[:submit_resume]	# resume after a pause by triggering a reload
			@hunt.resume_hunt
			@hunt.save
			render "reload.js"
		elsif params[:submit_continue]	# this is used if they re-view the instructions then continue
			redirect_to '/hunt_home/' + @hunt.id.to_s
		else	# it is an attempted answer, so check it
			f = File.open( XML_PATH + "products/#{@hunt.product.data_file}.xml" )
			huntxml = Nokogiri::XML(f)
			f.close
			clue_node = huntxml.xpath("//clues/clue[@number='#{@hunt.current_clue}']")
			if params[clue_node.xpath("answer").first.get_attribute("id").to_sym]
				@hunt.mark_time
				@hunt.next_clue
				@hunt.save
				render "answer.js"
			else
				@hunt.add_penalty 2		# 2 minutes for a wrong answer
				@hunt.save
				render "wrong.js"
			end
		end

	end
	
	def show_intro
		render "hunt_intro", layout: "hunt"
	end

	private

	def create_voucher_code
		if params[:voucher_code].blank? 
			@hunt.voucher_code = SecureRandom.hex(5) 
		end
	end
	
	def admin_user
		redirect_to root_path unless current_user.admin?
	end

end
