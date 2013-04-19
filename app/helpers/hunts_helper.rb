module HuntsHelper

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
