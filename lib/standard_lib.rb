module StandardLib
	# Returns a random alphanumeric string of arbitrary size.
	def random_alphanumeric(size=16)
		s = ""
		size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
		s
	end	
end
