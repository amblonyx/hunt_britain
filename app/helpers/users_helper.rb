module UsersHelper
	def output_address(user)
		if !user.nil?
			address = output_address_line(user.address_1)
			address += output_address_line(user.address_2)
			address += output_address_line(user.town)
			address += output_address_line(user.county)
			address += output_address_line(user.postcode)
			address += output_address_line(user.country)
			"<address>#{address}</address>".html_safe
		end
	end
	def output_address_line (line)
		output = ""
		output = line + "<br/>" unless line.blank?
		output.html_safe
	end
	def output_phone (line)
		output = ""
		output = "<abbr title='Phone'>P:</abbr> " + line + "<br/>" unless line.blank?
		output.html_safe
	end
end
