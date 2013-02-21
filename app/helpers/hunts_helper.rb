module HuntsHelper

	def five_answers(xml)	
		a = xml.xpath("//outcome/selection/*")
		aarray = []
		a.each do |node|
			aarray.push(node)
		end
		aarray.shuffle!
		afive = aarray[0..4]
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
