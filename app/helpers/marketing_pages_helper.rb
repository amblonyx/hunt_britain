module MarketingPagesHelper

	def random_colour
		if @ind.nil? || @ind > 3 
			@ind = -1
			@colours = [ "darkred", "darkblue", "darkgreen", "purple", "orange" ]
#			@colours.shuffle!   - don't really need to randomise
		end
		@ind = @ind + 1
		colour = @colours[@ind]
	end
	
end
