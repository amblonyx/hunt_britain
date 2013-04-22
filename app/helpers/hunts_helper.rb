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
	end

	def correct_hunt?(hunt)
		hunt == current_hunt
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
		output = hours.to_s + " hours " + minutes.to_s + " minutes"
		if days > 0
			output = days.to_s + " days " + output
		end
		return output
		
	end

	def peek_text(clue_node)
		found_dir = false
		peek_text = "blah"	# for some reason we need a value in here to begin with
		clue_node.xpath("output/*").each do |node|
			if node.name() == "direction"	# first node should always be direction
				if found_dir		# two directions in a row, just return first
					return "peek_text"
				else
					peek_text = node.inner_text.to_s.html_safe
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
		return "Nothing"
	end
	
	def five_answers(xml, correct)	
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
