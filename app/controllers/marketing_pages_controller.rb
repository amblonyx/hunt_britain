class MarketingPagesController < ApplicationController
	
	def home
		@locations = Location.all
		render layout: "marketing"		
	end
	
	def accordion
		@location = Location.find(params[:id])
		respond_to do |format|
			format.html
			format.js  { render "accordion.js" }
		end
	end
end
