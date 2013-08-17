module HuntsHelper

	# let and set...  @current_hunt is local variable
	def current_hunt=(hunt)
		@current_hunt = hunt
	end
	
	def current_hunt
		# if current_hunt is NOT nil, set it using voucher
		@current_hunt ||= Hunt.find_by_voucher_code(cookies[:voucher_code])
	end

	def sign_in_voucher(hunt)	
		cookies.permanent[:voucher_code] = hunt.voucher_code
		self.current_hunt = hunt
		
		#cache_xml(hunt)
	end

	def cache_xml(hunt)
		# Cache XML file
		#filepath = XML_PATH + "products/#{hunt.product.data_file}.xml"
		filepath = XML_PATH + "products/bath-easy.xml"
		xml = Rails.cache.fetch("huntxml_#{hunt.id}", :expires_in => 1.day) do
		  open(filepath).read
		end
		huntxml = Nokogiri::XML(xml)
	end
	
	def is_hunter?
		token_key = "hunter_token-#{current_hunt.id}"
		hunter_token = cookies[token_key.to_sym]
		current_hunt.hunter_token == hunter_token 
	end
	
	def set_hunter
		# allow synchronous access to hunt by "hunter" and "followers"
		# create a token for this session, save to cookies
		token_key = "hunter_token-#{current_hunt.id}"
		hunter_token = SecureRandom.urlsafe_base64
		cookies.permanent[token_key.to_sym] = hunter_token
		
		# set hunter_token in the hunts table 
		current_hunt.hunter_token = hunter_token
		current_hunt.save
	end 
	
	def is_group_hunt?
		!current_hunt.hunt_group.blank?
	end
	
	def get_hunts_in_group
		if is_group_hunt?
			hunt_group = current_hunt.hunt_group
			
			# Don't include the current hunt and only retrieve hunts where team name has been set
			Hunt.where("hunt_group = ? AND id != ? AND team_name is not null", hunt_group, current_hunt.id)
		else
			Hunt.none
		end
	end
	
	def get_hunt_info(hunt, use_self = false, penalties = true )
	
		penalties_string = ""
		if penalties 
			penalties_string = " including penalties"
		end 
		if hunt.completed?
			if use_self 
				info = "You completed the hunt in #{hunt_time(hunt)}#{penalties_string}."
			else
				info = "Team <b>#{hunt.team_name}</b> completed the hunt in #{hunt_time(hunt)}#{penalties_string}."
			end		
		elsif hunt.started?
			solved = hunt.current_clue-1
			if use_self 
				info = "So far it has taken you #{hunt_time(hunt)}#{penalties_string} to solve #{solved} #{"clue".pluralize(solved)}."
			else
				info = "Team <b>#{hunt.team_name}</b> has taken #{hunt_time(hunt)}#{penalties_string} to solve #{solved} #{"clue".pluralize(solved)}."
			end
		else
			if use_self 
				info = "You haven't started yet!"
			else
				info = "Team <b>#{hunt.team_name}</b> hasn't started yet."
			end		
		end
		return info.html_safe
	end
	
	def correct_hunt?(hunt)
		hunt == current_hunt
	end

	def get_coord(clue_node)
		clue_node.xpath("map/latlng").inner_text
	end
	
	def generate_static_map(clue_node)
		latlng = get_coord(clue_node)
		"http://maps.google.com/maps/api/staticmap?center=#{latlng}&markers=color:red|#{latlng}&zoom=16&size=250x250&sensor=false"
	end 
	
	def has_map?(clue_node)
		if clue_node.xpath("map").length > 0 
			true 
		else
			false
		end
	end
	
	def status_string(hunt)
		if hunt.completed?
			"Completed " +  l(hunt.last_submitted, format: :short)
		elsif hunt.started?
			"Started " + l(hunt.started_at, format: :short)
		else
			"Not started"
		end
	end

	def hunt_time(hunt)
	
		days = (hunt.time_taken/86400).floor
		hours = ((hunt.time_taken - (days * 86400))/3600).floor
		minutes = ((hunt.time_taken - (days * 86400) - (hours * 3600))/60).floor
		output = pluralize(hours, "hour") + " " + pluralize(minutes, "minute")
		if days > 0
			output = pluralize(days, "day") + " " + output
		end
		return output
		
	end

	def peek_text(clue_node)
		found_dir = false
		peek_text = "blah"	# for some reason we need a value in here to begin with
		clue_node.xpath("output/*").each do |node|
			if node.name() == "direction"	# first node should always be direction
				if found_dir		# two directions in a row, just return first
					return peek_text
				else
					peek_text = node.inner_text.to_s
					found_dir = true
					#return peek_text
				end 
			else
				if node.name() == "image" # won't be the first node so don't worry
					peek_text = peek_text.to_s + " [image]"
				end
				if found_dir
					return peek_text
				end
			end
		end
		return "The next clue is in the same location."
	end
	
	def six_answers(xml, correct)	
		# Put the answers that haven't been got yet in an array
		c = xml.xpath("//clues/clue[@number>'" + correct.to_s + "']")
		aarray = []
		c.each do |node|
			aarray.push(node)
		end
		# Also add the odd-one-out answer
		answernode = xml.xpath("//outcome/answer").first
		aarray.push(answernode)
		# Now get five random answers out (unless there are less than 5 already)
		if aarray.count > 5
			aarray.shuffle!
			afive = aarray[0..4]
		else
			afive = aarray
		end
		# Add the correct answer to the wrong ones, and shuffle again
		correctnode = xml.xpath("//clues/clue[@number='" + correct.to_s + "']").first
		afive.push(correctnode)
		afive.shuffle!
		# Put the six answers into a hash to return to the view
		n = 0
		afive.each do |node|
			ahash = {}
			ahash[:index] = n + 1
			ahash[:id] = node.get_attribute("number")
			ahash[:text] = node.xpath("option").inner_text
			afive[n] = ahash
			n = n + 1
		end
		return afive
		
	end

	def five_answers(xml, correct)	
		# This is the old method
		# Put the answers (except the correct one) in an array and get four random ones
		a = xml.xpath("//outcome/selection/option[@id!='" + correct + "']")
		aarray = []
		a.each do |node|
			aarray.push(node)
		end
		aarray.shuffle!
		afive = aarray[0..3]
		# Add the correct answer to the four, and shuffle again
		correctnode = xml.xpath("//outcome/selection/option[@id='" + correct + "']").first
		afive.push(correctnode)
		afive.shuffle!
		# Put the five answers into a hash to return to the view
		n = 0
		afive.each do |node|
			ahash = {}
			ahash[:index] = n + 1
			ahash[:id] = node.get_attribute("id")
			ahash[:text] = node.xpath("content").inner_text.to_s.html_safe
			afive[n] = ahash
			n = n + 1
		end
		return afive
	end
	
end
