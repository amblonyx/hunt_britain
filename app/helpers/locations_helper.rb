module LocationsHelper

	def transform_location(path)	
		require 'nokogiri'
	
		f = File.open( XML_PATH + "locations/" + path)
		doc = Nokogiri::XML(f)
		xslt  = Nokogiri::XSLT(File.read(XSL_PATH + "location.xslt"))
		f.close
		
		xslt.transform(doc)
	end
end
