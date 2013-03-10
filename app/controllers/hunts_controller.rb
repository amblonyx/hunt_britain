class HuntsController < ApplicationController
	
	def index
		@hunts = Hunt.paginate(page: params[:page])
	end

	def show
		@hunt = Hunt.find(params[:id])
		
		if params[:p] == "intro"
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
			@hunt.start
			@hunt.save
			redirect_to @hunt
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
		elsif params[:submit_pause]
			@hunt.pause_hunt
			@hunt.save
			render "reload.js"
		elsif params[:submit_resume]
			@hunt.resume_hunt
			@hunt.save
			render "reload.js"
		else
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

end
