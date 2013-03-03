module UsersHelper
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
