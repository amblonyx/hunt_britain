module HuntsHelper

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
